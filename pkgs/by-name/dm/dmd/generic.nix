{
  version,
  dmdHash,
  phobosHash,
}:

{
  stdenv,
  lib,
  fetchFromGitHub,
  removeReferencesTo,
  makeWrapper,
  which,
  writeTextFile,
  curl,
  tzdata,
  gdb,
  callPackage,
  targetPackages,
  fetchpatch,
  bash,
  installShellFiles,
  git,
  unzip,
  dmdBootstrap ? callPackage ./bootstrap.nix { },
  dmdBin ? "${dmdBootstrap}/bin",
}:

let
  dmdConfFile = writeTextFile {
    name = "dmd.conf";
    text = (
      lib.generators.toINI { } {
        Environment = {
          DFLAGS = ''-I@out@/include/dmd -L-L@out@/lib -fPIC ${
            lib.optionalString (!targetPackages.stdenv.cc.isClang) "-L--export-dynamic"
          }'';
        };
      }
    );
  };

  bits = toString stdenv.hostPlatform.parsed.cpu.bits;
  osname = if stdenv.hostPlatform.isDarwin then "osx" else stdenv.hostPlatform.parsed.kernel.name;

  pathToDmd = "\${NIX_BUILD_TOP}/dmd/generated/${osname}/release/${bits}/dmd";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "dmd";
  inherit version;

  enableParallelBuilding = true;

  srcs = [
    (fetchFromGitHub {
      owner = "dlang";
      repo = "dmd";
      rev = "v${finalAttrs.version}";
      hash = dmdHash;
      name = "dmd";
    })
    (fetchFromGitHub {
      owner = "dlang";
      repo = "phobos";
      rev = "v${finalAttrs.version}";
      hash = phobosHash;
      name = "phobos";
    })
  ];

  sourceRoot = ".";

  # https://issues.dlang.org/show_bug.cgi?id=19553
  hardeningDisable = [ "fortify" ];

  patches =
    lib.optionals (lib.versionOlder version "2.088.0") [
      # Migrates D1-style operator overloads in DMD source, to allow building with
      # a newer DMD
      (fetchpatch {
        url = "https://github.com/dlang/dmd/commit/c4d33e5eb46c123761ac501e8c52f33850483a8a.patch";
        stripLen = 1;
        extraPrefix = "dmd/";
        hash = "sha256-N21mAPfaTo+zGCip4njejasraV5IsWVqlGR5eOdFZZE=";
      })
    ]
    ++ [
      (fetchpatch {
        url = "https://github.com/dlang/dmd/commit/fdd25893e0ac04893d6eba8652903d499b7b0dfc.patch";
        stripLen = 1;
        extraPrefix = "dmd/";
        hash = "sha256-Uccb8rBPBLAEPWbOYWgdR5xN3wJoIkKKhLGu58IK1sM=";
      })
    ];

  postPatch = ''
    patchShebangs dmd/compiler/test/{runnable,fail_compilation,compilable,tools}{,/extra-files}/*.sh

    rm dmd/compiler/test/runnable/gdb1.d
    rm dmd/compiler/test/runnable/gdb10311.d
    rm dmd/compiler/test/runnable/gdb14225.d
    rm dmd/compiler/test/runnable/gdb14276.d
    rm dmd/compiler/test/runnable/gdb14313.d
    rm dmd/compiler/test/runnable/gdb14330.d
    rm dmd/compiler/test/runnable/gdb15729.sh
    rm dmd/compiler/test/runnable/gdb4149.d
    rm dmd/compiler/test/runnable/gdb4181.d
    rm dmd/compiler/test/compilable/ddocYear.d

    # Disable tests that rely on objdump whitespace until fixed upstream:
    #   https://issues.dlang.org/show_bug.cgi?id=23317
    rm dmd/compiler/test/runnable/cdvecfill.sh
    rm dmd/compiler/test/compilable/cdcmp.d
  ''
  + lib.optionalString (lib.versionAtLeast version "2.089.0" && lib.versionOlder version "2.092.2") ''
    rm dmd/compiler/test/dshell/test6952.d
  ''
  + lib.optionalString (lib.versionAtLeast version "2.092.2") ''
    substituteInPlace dmd/compiler/test/dshell/test6952.d --replace-fail "/usr/bin/env bash" "${bash}/bin/bash"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace phobos/std/socket.d --replace-fail "assert(ih.addrList[0] == 0x7F_00_00_01);" ""
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace phobos/std/socket.d --replace-fail "foreach (name; names)" "names = []; foreach (name; names)"
  '';

  nativeBuildInputs = [
    makeWrapper
    which
    installShellFiles
  ]
  ++ lib.optionals (lib.versionOlder version "2.088.0") [
    git
  ];

  buildInputs = [
    curl
    tzdata
  ];

  nativeCheckInputs = [
    gdb
  ]
  ++ lib.optionals (lib.versionOlder version "2.089.0") [
    unzip
  ];

  buildFlags = [
    "BUILD=release"
    "ENABLE_RELEASE=1"
    "PIC=1"
  ];

  # Build and install are based on http://wiki.dlang.org/Building_DMD
  buildPhase = ''
    runHook preBuild

    export buildJobs=$NIX_BUILD_CORES
    [ -z "$enableParallelBuilding" ] && buildJobs=1

    ${dmdBin}/rdmd dmd/compiler/src/build.d -j$buildJobs $buildFlags \
      HOST_DMD=${dmdBin}/dmd
    make -C dmd/druntime -j$buildJobs DMD=${pathToDmd} $buildFlags
    echo ${tzdata}/share/zoneinfo/ > TZDatabaseDirFile
    echo ${lib.getLib curl}/lib/libcurl${stdenv.hostPlatform.extensions.sharedLibrary} \
      > LibcurlPathFile
    make -C phobos -j$buildJobs $buildFlags \
      DMD=${pathToDmd} DFLAGS="-version=TZDatabaseDir -version=LibcurlPath -J$PWD"

    runHook postBuild
  '';

  doCheck = true;

  # many tests are disabled because they are failing

  # NOTE: Purity check is disabled for checkPhase because it doesn't fare well
  # with the DMD linker. See https://github.com/NixOS/nixpkgs/issues/97420
  checkPhase = ''
    runHook preCheck

    export checkJobs=$NIX_BUILD_CORES
    [ -z "$enableParallelChecking" ] && checkJobs=1

    CC=$CXX HOST_DMD=${pathToDmd} NIX_ENFORCE_PURITY= \
      ${dmdBin}/rdmd dmd/compiler/test/run.d -j$checkJobs

    NIX_ENFORCE_PURITY= \
      make -C phobos unittest -j$checkJobs $checkFlags \
        DFLAGS="-version=TZDatabaseDir -version=LibcurlPath -J$PWD"

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ${pathToDmd} $out/bin/dmd

    installManPage dmd/docs/man/man*/*

    mkdir -p $out/include/dmd
    cp -r {dmd/druntime/import/*,phobos/{std,etc}} $out/include/dmd/

    mkdir $out/lib
    cp phobos/generated/${osname}/release/${bits}/libphobos2.* $out/lib/

    wrapProgram $out/bin/dmd \
      --prefix PATH : "${targetPackages.stdenv.cc}/bin" \
      --set-default CC "${targetPackages.stdenv.cc}/bin/cc"

    substitute ${dmdConfFile} "$out/bin/dmd.conf" --subst-var out

    runHook postInstall
  '';

  preFixup = ''
    find $out/bin -type f -exec ${removeReferencesTo}/bin/remove-references-to -t ${dmdBin}/dmd '{}' +
  '';

  disallowedReferences = [ dmdBootstrap ];

  passthru = {
    inherit dmdBootstrap;
  };

  meta = with lib; {
    description = "Official reference compiler for the D language";
    homepage = "https://dlang.org/";
    changelog = "https://dlang.org/changelog/${finalAttrs.version}.html";
    # Everything is now Boost licensed, even the backend.
    # https://github.com/dlang/dmd/pull/6680
    license = licenses.boost;
    mainProgram = "dmd";
    maintainers = with maintainers; [
      lionello
      dukc
      jtbx
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
    ];
    # ld: section __DATA/__thread_bss has type zero-fill but non-zero file offset file '/private/tmp/nix-build-dmd-2.109.1.drv-0/.rdmd-301/rdmd-build.d-A1CF043A7D87C5E88A58F3C0EF5A0DF7/objs/build.o' for architecture x86_64
    # clang-16: error: linker command failed with exit code 1 (use -v to see invocation)
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
  };
})
