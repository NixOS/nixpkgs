{
  autoAddDriverRunpath,
  autoPatchelfHook,
  fetchurl,
  lib,
  libbsd,
  libtinfo,
  makeWrapper,
  patchelf,
  python3,
  runCommand,
  stdenv,
  unzip,
}:

let
  release = builtins.fromJSON (builtins.readFile ./sources.json);
  systemSources = release.systems.${stdenv.hostPlatform.system};
  fetchWheel = source: fetchurl { inherit (source) url hash; };
  pythonDependencies = with python3.pkgs; [
    click
    mypy-extensions
    pathspec
    platformdirs
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mojo";
  inherit (release) version;

  strictDeps = true;
  __structuredAttrs = true;

  # The full `mojo` wheel depends on the compiler, precompiled standard library,
  # LLDB support, and mblack wheels. MAX's core runtime and Mojo libraries are
  # also required for accelerator compilation. They must share one prefix, as
  # with pip. max-shmem-libs is intentionally omitted: it is an optional
  # distributed-GPU facility, is not linked by the core runtime, and upstream
  # does not publish it for aarch64-linux.
  srcs = map fetchWheel [
    systemSources.mojo
    systemSources.mojoCompiler
    systemSources.mojoLldbLibs
    systemSources.maxCore
    release.common.mojoCompilerMojoLibs
    release.common.maxMojoLibs
    release.common.mblack
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    autoAddDriverRunpath
    makeWrapper
    unzip
  ];

  buildInputs = [
    libbsd
    # Upstream LLDB links to the non-wide ncurses, panel, and terminfo ABI.
    libtinfo
    stdenv.cc.cc.lib
  ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack

    mkdir wheels
    wheelNumber=0
    for wheel in "''${srcs[@]}"; do
      wheelNumber=$((wheelNumber + 1))
      mkdir "wheels/$wheelNumber"
      unzip -q "$wheel" -d "wheels/$wheelNumber"
    done

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    sitePackages=$out/${python3.sitePackages}
    mkdir -p "$sitePackages" $out/bin

    for wheel in wheels/*; do
      for platlib in "$wheel"/*.data/platlib; do
        if [ -d "$platlib" ]; then
          cp -a "$platlib"/. "$sitePackages"/
        fi
      done

      for entry in "$wheel"/*; do
        case "$entry" in
          *.data) ;;
          *) cp -a "$entry" "$sitePackages"/ ;;
        esac
      done
    done

    # NIXL's transport plugins implement optional distributed and multi-GPU
    # communication and require UCX, libfabric, RDMA, or ROCm stacks. Keep the
    # core NIXL library used by libmax, but omit those out-of-scope plugins.
    rm -rf "$sitePackages/modular/lib/nixl"

    writeEntryPoint() {
      local program=$1
      local module=$2
      local function=$3

      cat > "$out/bin/$program" <<EOF
    #!${python3.interpreter}
    import sys
    sys.path[:0] = ["$sitePackages"] + "${python3.pkgs.makePythonPath pythonDependencies}".split(":")
    from $module import $function
    $function()
    EOF
      chmod +x "$out/bin/$program"
    }

    # Recreate the wheels' console_scripts instead of exposing the underlying
    # native payloads directly. These entrypoints establish the SDK environment.
    writeEntryPoint mojo mojo._entrypoints exec_mojo
    writeEntryPoint lld mojo._entrypoints exec_lld
    writeEntryPoint modular-crashpad-handler mojo._entrypoints exec_modular_crashpad_handler
    writeEntryPoint gpu-query _mojo._entrypoints exec_gpu_query
    writeEntryPoint lldb-argdumper _mojo._entrypoints exec_lldb_argdumper
    writeEntryPoint lldb-server _mojo._entrypoints exec_lldb_server
    writeEntryPoint llvm-symbolizer _mojo._entrypoints exec_llvm_symbolizer
    writeEntryPoint mojo-lldb _mojo._entrypoints exec_mojo_lldb
    writeEntryPoint mojo-lsp-server _mojo._entrypoints exec_mojo_lsp_server
    writeEntryPoint mblack mblack patched_main

    # Unlike the other console scripts, lldb-dap supplies plugin and visualizer
    # setup. The wheel expects these two defaults in its process environment.
    cat > $out/bin/lldb-dap <<EOF
    #!${python3.interpreter}
    import os
    import sys
    sys.path[:0] = ["$sitePackages"] + "${python3.pkgs.makePythonPath pythonDependencies}".split(":")
    os.environ.setdefault("MODULAR_MOJO_MAX_LLDB_PLUGIN_PATH", "$sitePackages/modular/lib/libMojoLLDB.so")
    os.environ.setdefault("MODULAR_MOJO_MAX_LLDB_VISUALIZERS_PATH", "$sitePackages/modular/lib/lldb-visualizers")
    from _mojo._entrypoints import exec_lldb_dap
    exec_lldb_dap()
    EOF
    chmod +x $out/bin/lldb-dap

    runHook postInstall
  '';

  postFixup = ''
    for program in \
      gpu-query \
      lld \
      lldb-argdumper \
      lldb-dap \
      lldb-server \
      llvm-symbolizer \
      modular-crashpad-handler \
      mojo-lldb \
      mojo-lsp-server
    do
      wrapProgram "$out/bin/$program" --prefix PATH : "$out/bin"
    done

    wrapProgram "$out/bin/mojo" \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ stdenv.cc ]}"
  '';

  passthru = {
    tests = import ./tests.nix {
      inherit (finalAttrs) finalPackage;
      inherit (stdenv) shell;
      inherit patchelf runCommand;
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Programming language and developer toolchain for heterogeneous computing";
    longDescription = ''
      The prebuilt Linux toolchain requires an x86-64-v3 processor on x86_64,
      or an ARM Neoverse N1 processor or newer on aarch64. It includes the MAX
      core runtime needed for accelerator compilation, but not MAX's optional
      distributed multi-GPU SHMEM support.
    '';
    homepage = "https://www.modular.com/mojo";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ samuela ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    mainProgram = "mojo";
  };
})
