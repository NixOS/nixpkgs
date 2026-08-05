{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  cargo,
  cmake,
  cups,
  coreutils,
  gfortran,
  gitMinimal,
  glib,
  gobject-introspection,
  hdf5-fortran,
  jdk,
  libblocksruntime,
  llvmPackages,
  meson,
  nasm,
  netcdf,
  ninja,
  pkg-config,
  python3,
  ncurses,
  libxml2,
  qt6,
  replaceVars,
  rustc,
  writableTmpDirAsHomeHook,
  writeShellScriptBin,
  zlib,
  # This field is intended for internal nixpkgs use (to break dependency cycles).
  # It is a positive integer specifying the level of additional tests to run.
  # 0 is the default.
  # At the moment, 1 is more tests (and a larger closure),
  # 2 is even more (including LLVM/clang/rustc in the closure).
  _extraTests ? 0,
}:

let
  boost' = python3.pkgs.boost.override { enableStatic = true; };
in
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "meson";
  version = "1.11.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mesonbuild";
    repo = "meson";
    tag = finalAttrs.version;
    hash = "sha256-HGXNrw39TfNio64BH0DhSAj8zz6XLwuG0RhOfCxT2PU=";
  };

  patches = [
    # Nixpkgs cmake uses NIXPKGS_CMAKE_PREFIX_PATH for the search path
    ./000-nixpkgs-cmake-prefix-path.patch

    # In typical distributions, RPATH is only needed for internal libraries so
    # meson removes everything else. With Nix, the locations of libraries
    # are not as predictable, therefore we need to keep them in the RPATH.
    # At the moment we are keeping the paths starting with /nix/store.
    # https://github.com/NixOS/nixpkgs/issues/31222#issuecomment-365811634
    (replaceVars ./001-fix-rpath.patch {
      inherit (builtins) storeDir;
    })

    # When Meson removes build_rpath from DT_RUNPATH entry, it just writes
    # the shorter NUL-terminated new rpath over the old one to reduce
    # the risk of potentially breaking the ELF files.
    # But this can cause much bigger problem for Nix as it can produce
    # cut-in-half-by-\0 store path references.
    # Let’s just clear the whole rpath and hope for the best.
    ./002-clear-old-rpath.patch

    # Meson is currently inspecting fewer variables than autoconf does, which
    # makes it harder for us to use setup hooks, etc.
    # https://github.com/mesonbuild/meson/pull/6827
    ./003-more-env-vars.patch

    # Unlike libtool, vanilla Meson does not pass any information about the path
    # library will be installed to to g-ir-scanner, breaking the GIR when path
    # other than ${!outputLib}/lib is used.
    # We patch Meson to add a --fallback-library-path argument with library
    # install_dir to g-ir-scanner.
    ./004-gir-fallback-path.patch

    # Patch out default boost search paths to avoid impure builds on
    # unsandboxed non-NixOS builds, see:
    # https://github.com/NixOS/nixpkgs/issues/86131#issuecomment-711051774
    ./005-boost-Do-not-add-system-paths-on-nix.patch

    # This edge case is explicitly part of meson but is wrong for nix
    ./007-freebsd-pkgconfig-path.patch
  ];

  ${if python3.isPyPy then "postPatch" else null} = ''
    substituteInPlace mesonbuild/modules/python.py \
      --replace-fail "PythonExternalProgram('python3', mesonlib.python_command" \
                      "PythonExternalProgram('${python3.meta.mainProgram}', mesonlib.python_command"
    substituteInPlace mesonbuild/modules/python3.py \
      --replace-fail "state.environment.lookup_binary_entry(mesonlib.MachineChoice.HOST, 'python3'" \
                      "state.environment.lookup_binary_entry(mesonlib.MachineChoice.HOST, '${python3.meta.mainProgram}'"
    substituteInPlace "test cases"/*/*/*.py "test cases"/*/*/*/*.py \
      --replace-quiet '#!/usr/bin/env python3' '#!/usr/bin/env pypy3' \
      --replace-quiet '#! /usr/bin/env python3' '#!/usr/bin/env pypy3'
    chmod +x "test cases"/*/*/*.py "test cases"/*/*/*/*.py
  '';

  build-system = [ python3.pkgs.setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  optional-dependencies = {
    ninja = [ python3.pkgs.ninja ];
    progress = [ python3.pkgs.tqdm ];
    typing = [ python3.pkgs.mypy ];
  };

  ${if _extraTests > 0 then "dontUseCmakeConfigure" else null} = true;
  ${if _extraTests > 1 then "dontUseQmakeConfigure" else null} = true;
  ${if _extraTests > 1 then "dontWrapQtApps" else null} = true;

  nativeCheckInputs = [
    ninja
    pkg-config
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals python3.isPyPy [
    # Several tests hardcode python3.
    (writeShellScriptBin "python3" ''exec pypy3 "$@"'')
  ]
  ++ lib.optionals (_extraTests > 0) [
    cmake
    gfortran
    gitMinimal
    glib # glib-compile-resources
    nasm
    python3.pkgs.cython
  ]
  ++ lib.optionals (_extraTests > 1) [
    cargo
    gobject-introspection # g-ir-scanner
    jdk
    llvmPackages.clang
    llvmPackages.llvm
    qt6.qmake
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qttools
    rustc
  ];

  checkInputs = [
    zlib
  ]
  ++ lib.optionals (_extraTests > 0) [
    boost'
    boost'.dev
    glib
    hdf5-fortran
    netcdf
    python3 # required by "test cases/python3/3 cython/meson.build"
  ]
  ++ lib.optionals (_extraTests > 1) [
    cups.dev
    cups.lib
    libxml2
    libxml2.dev
    llvmPackages.llvm.dev
    llvmPackages.llvm.lib
    ncurses
    ncurses.dev
  ]
  ++ lib.optionals (_extraTests > 1 && stdenv.cc.isClang) [
    # https://github.com/mesonbuild/meson/blob/1670fca36fcb1a4fe4780e96731e954515501a35/test%20cases/frameworks/29%20blocks/meson.build
    libblocksruntime
    # https://github.com/mesonbuild/meson/blob/bd3f1b2e0e70ef16dfa4f441686003212440a09b/test%20cases/common/184%20openmp/meson.build
    llvmPackages.openmp
    llvmPackages.openmp.dev
  ];

  checkPhase = lib.concatStringsSep "\n" (
    [
      "runHook preCheck"
      ''
        patchShebangs 'test cases'
        substituteInPlace \
          'test cases/native/8 external program shebang parsing/script.int.in' \
          'test cases/common/274 customtarget exe for test/generate.py' \
            --replace-fail /usr/bin/env ${lib.getExe' coreutils "env"}
        substituteInPlace run_project_tests.py \
          --replace-fail "multiprocessing.cpu_count()" "int(os.environ['NIX_BUILD_CORES'])"
      ''
    ]
    ++ lib.optionals (_extraTests > 1) [
      # For some reason, this variable is TRUE and not ON.
      ''
        substituteInPlace 'test cases/common/211 dependency get_variable method/meson.build' \
          --replace-fail \
            "dep_cm.get_variable(cmake : 'LLVM_ENABLE_RTTI') == 'ON')" \
            "dep_cm.get_variable(cmake : 'LLVM_ENABLE_RTTI') == 'TRUE')"
        substituteInPlace "test cases/python3/3 cython/meson.build" \
          --replace-fail \
            "find_program('cython3'" \
            "find_program('${python3.pkgs.cython.meta.mainProgram}'"
      ''
    ]
    # Remove problematic tests
    ++ (map (f: ''rm -vr "${f}";'') (
      [
        # Nixpkgs cctools does not have bitcode support.
        "test cases/osx/7 bitcode"
        # This test tries to compile with flags `-D_FORTIFY_SOURCE=2 -U_FORTIFY_SOURCE -O0`.
        # It fails because cc-wrapper adds `-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3`
        # after the provided args (to ensure that fortify cannot be disabled without
        # being allowed by the package definition)
        "test cases/common/282 -D_FORTIFY_SOURCE=2 and -O0"
        # requires static zlib, see #66461
        "test cases/linuxlike/14 static dynamic linkage"
      ]
      ++ lib.optionals (_extraTests < 1) [
        # requires git, creating cyclic dependency
        "test cases/common/66 vcstag"
        # requires glib, creating cyclic dependency
        "test cases/linuxlike/6 subdir include order"
        "test cases/linuxlike/9 compiler checks with dependencies"
      ]
      ++ lib.optionals (stdenv.cc.isClang) [
        # _extraTests < 2: needs llvmPackages.openmp
        # _extraTests >= 2: seems to require both headers from llvmPackages.openmp.dev (for C/C++) and gfortran.
        "test cases/common/184 openmp"
      ]
      ++ lib.optionals (stdenv.hostPlatform.isDarwin && _extraTests > 1) [
        # These expect libraries to be .so files, not .dylib files.
        "test cases/frameworks/12 multiple gir"
        "test cases/frameworks/34 gir static lib"
      ]
      ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
        # pch doesn't work quite right on FreeBSD, I think
        "test cases/common/13 pch"
      ]
      ++ lib.optionals python3.isPyPy [
        # fails for unknown reason
        "test cases/python/4 custom target depends extmodule"
        # we patch the path to the binary...
        "test cases/common/26 find program"
      ]
    ))
    ++ [
      "${if python3.isPyPy then python3.interpreter else "python"} ./run_project_tests.py"
      "runHook postCheck"
    ]
  );

  postInstall = ''
    installShellCompletion \
      --bash data/shell-completions/bash/meson \
      --zsh data/shell-completions/zsh/_meson
  '';

  postFixup = ''
    pushd $out/bin
    # undo shell wrapper as meson tools are called with python
    for i in *; do
      mv ".$i-wrapped" "$i"
    done
    popd

    # Do not propagate Python
    rm $out/nix-support/propagated-build-inputs

    substituteInPlace "$out/share/bash-completion/completions/meson" \
      --replace-fail "python3 -c " "${python3.interpreter} -c "
  '';

  setupHook = ./setup-hook.sh;
  env.hostPlatform = stdenv.targetPlatform.system;
  passthru.tests = {
    extraTests1 = meson.override { _extraTests = 1; };
    extraTests2 = meson.override { _extraTests = 2; };
  };

  meta = {
    homepage = "https://mesonbuild.com";
    description = "Open source, fast and friendly build system made in Python";
    mainProgram = "meson";
    longDescription = ''
      Meson is an open source build system meant to be both extremely fast, and,
      even more importantly, as user friendly as possible.

      The main design point of Meson is that every moment a developer spends
      writing or debugging build definitions is a second wasted. So is every
      second spent waiting for the build system to actually start compiling
      code.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ qyliss ];
    inherit (python3.meta) platforms;
  };
})
