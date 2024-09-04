{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, coreutils
, darwin
, libblocksruntime
, llvmPackages
, libxcrypt
, openldap
, ninja
, pkg-config
, python3
, substituteAll
, zlib
, fetchpatch
}:

let
  inherit (darwin.apple_sdk.frameworks) AppKit Cocoa Foundation LDAP OpenAL OpenGL;
in
python3.pkgs.buildPythonApplication rec {
  pname = "meson";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "mesonbuild";
    repo = "meson";
    rev = "refs/tags/${version}";
    hash = "sha256-BqsEO1a93a8d7/UH232buSPBt+WSNJbw1DGYA2nm9rs=";
  };

  patches = [
    # Nixpkgs cmake uses NIXPKGS_CMAKE_PREFIX_PATH for the search path
    ./000-nixpkgs-cmake-prefix-path.patch

    # In typical distributions, RPATH is only needed for internal libraries so
    # meson removes everything else. With Nix, the locations of libraries
    # are not as predictable, therefore we need to keep them in the RPATH.
    # At the moment we are keeping the paths starting with /nix/store.
    # https://github.com/NixOS/nixpkgs/issues/31222#issuecomment-365811634
    (substituteAll {
      src = ./001-fix-rpath.patch;
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

    # Nixpkgs cctools does not have bitcode support.
    ./006-disable-bitcode.patch

    # This edge case is explicitly part of meson but is wrong for nix
    ./007-freebsd-pkgconfig-path.patch

    (fetchpatch {
      name = "tests-skip-framework-recasting-if-CMake-unavailable.patch";
      url = "https://github.com/mesonbuild/meson/commit/8a8a3a0578fd8d5a8720a7a706f6f3b99e857f9c.patch";
      hash = "sha256-XkwNQ5eg/fVekhsFg/V2/S2LbIVGz3H0wsSFlUT3ZZE=";
    })

    # Fix extraframework lookup on case-sensitive APFS.
    # https://github.com/mesonbuild/meson/pull/13038
    ./007-case-sensitive-fs.patch

    # Fix meson's detection for zig's linker
    # https://github.com/mesonbuild/meson/pull/12293
    (fetchpatch {
      name = "linker-support-zig-cc.patch";
      url = "https://github.com/mesonbuild/meson/pull/12293/commits/2baae244c995794d9addfe6ed924dfa72f01be82.patch";
      hash = "sha256-dDOmSRBKl/gs7I3kmLXIyQk3zsOdlaYov72pPSel4+I=";
    })
  ];

  buildInputs = lib.optionals (python3.pythonOlder "3.9") [
    libxcrypt
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    ninja
    pkg-config
  ];

  checkInputs = [
    zlib
  ]
  ++ lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    Foundation
    LDAP
    OpenAL
    OpenGL
    openldap
  ] ++ lib.optionals (stdenv.cc.isClang && !stdenv.isDarwin) [
    # https://github.com/mesonbuild/meson/blob/bd3f1b2e0e70ef16dfa4f441686003212440a09b/test%20cases/common/184%20openmp/meson.build
    llvmPackages.openmp
    # https://github.com/mesonbuild/meson/blob/1670fca36fcb1a4fe4780e96731e954515501a35/test%20cases/frameworks/29%20blocks/meson.build
    libblocksruntime
  ];

  checkPhase = lib.concatStringsSep "\n" ([
    "runHook preCheck"
    ''
      patchShebangs 'test cases'
      substituteInPlace \
        'test cases/native/8 external program shebang parsing/script.int.in' \
        'test cases/common/273 customtarget exe for test/generate.py' \
          --replace /usr/bin/env ${coreutils}/bin/env
    ''
  ]
  # Remove problematic tests
  ++ (builtins.map (f: ''rm -vr "${f}";'') ([
    # requires git, creating cyclic dependency
    ''test cases/common/66 vcstag''
    # requires glib, creating cyclic dependency
    ''test cases/linuxlike/6 subdir include order''
    ''test cases/linuxlike/9 compiler checks with dependencies''
    # requires static zlib, see #66461
    ''test cases/linuxlike/14 static dynamic linkage''
    # Nixpkgs cctools does not have bitcode support.
    ''test cases/osx/7 bitcode''
  ] ++ lib.optionals stdenv.isDarwin [
    # requires llvmPackages.openmp, creating cyclic dependency
    ''test cases/common/184 openmp''
  ] ++ lib.optionals stdenv.isFreeBSD [
    # pch doesn't work quite right on FreeBSD, I think
    ''test cases/common/13 pch''
  ]))
  ++ [
    ''HOME="$TMPDIR" python ./run_project_tests.py''
    "runHook postCheck"
  ]);

  postInstall = ''
    installShellCompletion --zsh data/shell-completions/zsh/_meson
    installShellCompletion --bash data/shell-completions/bash/meson
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
      --replace "python3 -c " "${python3.interpreter} -c "
  '';

  setupHook = ./setup-hook.sh;

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
    maintainers = with lib.maintainers; [ AndersonTorres qyliss ];
    inherit (python3.meta) platforms;
  };
}
# TODO: a more Nixpkgs-tailoired test suite
