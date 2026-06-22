{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  unzip,
  python3,
  zlib,
  ncurses,
  libxml2,
  libffi,
  libbsd,
}:

let
  version = "1.0.0b2.dev2026052421";
  mblackVersion = "26.4.0.dev2026052421";

  pythonEnv = python3.withPackages (
    ps: with ps; [
      click
      mypy-extensions
      pathspec
      platformdirs
    ]
  );

  pythonPath = lib.makeSearchPath python3.sitePackages [
    pythonEnv
  ];

  ncursesCompat = ncurses.override {
    abiVersion = "6";
    unicodeSupport = false;
    withTermlib = true;
  };

  wheelBaseUrl = "https://us-central1-python.pkg.dev/distribution-prod-0a7c7b3/nightly";
in
stdenv.mkDerivation {
  pname = "mojo";
  inherit version;

  __structuredAttrs = true;

  srcs = [
    (fetchurl {
      name = "mojo-${version}-py3-none-manylinux_2_34_x86_64.whl";
      url = "${wheelBaseUrl}/mojo/mojo-${version}-py3-none-manylinux_2_34_x86_64.whl";
      hash = "sha256-u2WXCFJPRGZ8YgXYQaD2hSTRMAx/qa1zU1KRIihKIyE=";
    })
    (fetchurl {
      name = "mojo_compiler-${version}-py3-none-manylinux_2_34_x86_64.whl";
      url = "${wheelBaseUrl}/mojo-compiler/mojo_compiler-${version}-py3-none-manylinux_2_34_x86_64.whl";
      hash = "sha256-trOhIvHdW84AlqiT8FYQYCrKLJ18snJWYcYW431Lqwg=";
    })
    (fetchurl {
      name = "mojo_compiler_mojo_libs-${version}-py3-none-any.whl";
      url = "${wheelBaseUrl}/mojo-compiler-mojo-libs/mojo_compiler_mojo_libs-${version}-py3-none-any.whl";
      hash = "sha256-EOzd1SCAl2YhoLyT32YDbE5koxeKV1fsIklEc9dLz5g=";
    })
    (fetchurl {
      name = "mblack-${mblackVersion}-py3-none-any.whl";
      url = "${wheelBaseUrl}/mblack/mblack-${mblackVersion}-py3-none-any.whl";
      hash = "sha256-MY25pYON+GgarAIHyEBb5zs0spWqwSqfMT0zCS7lz7c=";
    })
    (fetchurl {
      name = "mojo_lldb_libs-${version}-py3-none-manylinux_2_34_x86_64.whl";
      url = "${wheelBaseUrl}/mojo-lldb-libs/mojo_lldb_libs-${version}-py3-none-manylinux_2_34_x86_64.whl";
      hash = "sha256-aTlnF98uBYMwpvkJaiKZonGJlcL7m0P9xA9NjEkqLHY=";
    })
  ];

  dontUnpack = true;

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    unzip
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    ncursesCompat
    libxml2
    libffi
    libbsd
  ];

  appendRunpaths = [ "${placeholder "out"}/${python3.sitePackages}/modular/lib" ];

  installPhase = ''
    runHook preInstall

    sitePackages="$out/${python3.sitePackages}"
    mkdir -p "$sitePackages" "$out/bin"

    for wheel in "''${srcs[@]}"; do
      unzip -q "$wheel" -d "$sitePackages"
    done

    for dataDir in "$sitePackages"/*.data/platlib; do
      if [ -d "$dataDir" ]; then
        cp -R "$dataDir"/* "$sitePackages/"
      fi
    done

    rm -rf "$sitePackages"/*.data
    chmod -R u+w "$sitePackages"

    modularRoot="$sitePackages/modular"
    wrapperArgs=(
      --prefix PYTHONPATH : "$sitePackages:${pythonPath}"
      --set MODULAR_MAX_PACKAGE_ROOT "$modularRoot"
      --set MODULAR_MOJO_MAX_PACKAGE_ROOT "$modularRoot"
      --set MODULAR_MOJO_MAX_DRIVER_PATH "$modularRoot/bin/mojo"
      --set MODULAR_MOJO_MAX_IMPORT_PATH "$modularRoot/lib/mojo"
      --set MODULAR_MOJO_MAX_MBLACK_PATH "$out/bin/mblack"
      --set MODULAR_MOJO_MAX_LLDB_PLUGIN_PATH "$modularRoot/lib/libMojoLLDB.so"
      --set MODULAR_MOJO_MAX_LLDB_VISUALIZERS_PATH "$modularRoot/lib/lldb-visualizers"
    )

    find "$modularRoot/bin" -type f -exec chmod +x {} +
    find "$modularRoot/lib" -type f -name '*.so*' -exec chmod +x {} +

    makeBinaryEntrypoint() {
      local name="$1"
      local target="$2"

      makeWrapper "$target" "$out/bin/$name" "''${wrapperArgs[@]}"
    }

    makePythonEntrypoint() {
      local name="$1"
      local module="$2"
      local function="$3"

      printf '%s\n' \
        "#!${pythonEnv}/bin/python" \
        "import sys" \
        "from $module import $function" \
        "sys.exit($function())" \
        > "$out/bin/$name"
      chmod +x "$out/bin/$name"

      wrapProgram "$out/bin/$name" "''${wrapperArgs[@]}"
    }

    makeBinaryEntrypoint mojo "$modularRoot/bin/mojo"
    makeBinaryEntrypoint lld "$modularRoot/bin/lld"
    makeBinaryEntrypoint modular-crashpad-handler "$modularRoot/bin/modular-crashpad-handler"
    makePythonEntrypoint mblack mblack patched_main
    makePythonEntrypoint gpu-query _mojo._entrypoints exec_gpu_query
    makePythonEntrypoint lldb-argdumper _mojo._entrypoints exec_lldb_argdumper
    makePythonEntrypoint lldb-dap _mojo._entrypoints exec_lldb_dap
    makePythonEntrypoint lldb-server _mojo._entrypoints exec_lldb_server
    makePythonEntrypoint llvm-symbolizer _mojo._entrypoints exec_llvm_symbolizer
    makePythonEntrypoint mojo-lldb _mojo._entrypoints exec_mojo_lldb
    makePythonEntrypoint mojo-lsp-server _mojo._entrypoints exec_mojo_lsp_server

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
        runHook preInstallCheck

        "$out/bin/mojo" --version
        cat > hello.mojo <<'EOF'
    def main():
        print("Hello, Mojo")
    EOF
        export HOME="$PWD/home"
        export XDG_CACHE_HOME="$HOME/.cache"
        export XDG_DATA_HOME="$HOME/.local/share"
        mkdir -p "$XDG_CACHE_HOME" "$XDG_DATA_HOME"
        "$out/bin/mojo" hello.mojo
        "$out/bin/mojo-lldb" --version

        runHook postInstallCheck
  '';

  meta = {
    description = "Programming language for AI developers";
    homepage = "https://mojolang.org";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "mojo";
    maintainers = with lib.maintainers; [ vadim-su ];
    platforms = [ "x86_64-linux" ];
  };
}
