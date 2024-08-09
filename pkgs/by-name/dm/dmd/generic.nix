{ version
, dmdRevision ? "v${version}"
, phobosRevision ? "v${version}"
, dmdHash
, phobosHash
, bootstrap ? false
}:

{ stdenv
, lib
, callPackage
, fetchFromGitHub
, fetchpatch
, installShellFiles
, makeWrapper
, removeReferencesTo
, targetPackages
, writeTextFile
, bash
, curl
, darwin
, gdb
, git
, tzdata
, unzip
, which

, dmdBootstrap ?
  if !bootstrap then
    callPackage ./bootstrap.nix { }
  else
    null
, dmdBin ?
  if !bootstrap then
    lib.getExe dmdBootstrap
  else
    ""
}:

let
  dmdConfFile = writeTextFile {
    name = "dmd.conf";
    text = (lib.generators.toINI { } {
      Environment = {
        DFLAGS = ''-I@out@/include/dmd -L-L@out@/lib -fPIC ${lib.optionalString (!targetPackages.stdenv.cc.isClang) "-L--export-dynamic"}'';
      };
    });
  };
  # TODO: move dmd.conf for non-bootstrap builds to etc/
  dmdConfPath = "$out/${if bootstrap then "etc" else "bin"}/dmd.conf";
  druntimeImport = (lib.optionalString (!bootstrap) "dmd/") + "druntime/import/";
  bits = builtins.toString stdenv.hostPlatform.parsed.cpu.bits;
  osname =
    if stdenv.isDarwin then
      "osx"
    else
      stdenv.hostPlatform.parsed.kernel.name;
  pathToDmd = "\${NIX_BUILD_TOP}/dmd/generated/${osname}/release/${bits}/dmd";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "dmd"
    + lib.optionalString bootstrap "-bootstrap";
  inherit version;

  enableParallelBuilding = true;

  srcs = [
    (fetchFromGitHub {
      owner = "dlang";
      repo = "dmd";
      rev = dmdRevision;
      hash = dmdHash;
      name = "dmd";
    })
    (fetchFromGitHub {
      owner = "dlang";
      repo = "phobos";
      rev = phobosRevision;
      hash = phobosHash;
      name = "phobos";
    })
  ] ++ lib.optionals bootstrap [
    (fetchFromGitHub {
      owner = "dlang";
      repo = "druntime";
      rev = "98c6ff0cf1241a0cfac196bf8a0523b1d4ecd3ac";
      hash = "sha256-4xhPzyNeafuayy39wAlXiJ+eD0eXcpcgPPMxELGlcMk=";
      name = "druntime";
    })
  ];

  sourceRoot = ".";

  # https://issues.dlang.org/show_bug.cgi?id=19553
  hardeningDisable = [ "fortify" ];

  patches = lib.optionals bootstrap [
    ./bootstrap-sysconfdir.diff
  ] ++ lib.optionals (!bootstrap && lib.versionOlder version "2.088.0") [
    # Migrates D1-style operator overloads in DMD source, to allow building with
    # a newer DMD
    (fetchpatch {
      url = "https://github.com/dlang/dmd/commit/c4d33e5eb46c123761ac501e8c52f33850483a8a.patch";
      stripLen = 1;
      extraPrefix = "dmd/";
      hash = "sha256-N21mAPfaTo+zGCip4njejasraV5IsWVqlGR5eOdFZZE=";
    })
  ];

  postPatch = ''
  '' + lib.optionalString bootstrap ''
    substituteInPlace dmd/src/inifile.c \
      --subst-var out
  '' + lib.optionalString (!bootstrap) ''
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
  '' + lib.optionalString (lib.versionAtLeast version "2.089.0" && lib.versionOlder version "2.092.2") ''
    rm dmd/compiler/test/dshell/test6952.d
  '' + lib.optionalString (lib.versionAtLeast version "2.092.2") ''
    substituteInPlace dmd/compiler/test/dshell/test6952.d --replace-fail "/usr/bin/env bash" "${bash}/bin/bash"
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace phobos/std/socket.d --replace-fail "assert(ih.addrList[0] == 0x7F_00_00_01);" ""
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace phobos/std/socket.d --replace-fail "foreach (name; names)" "names = []; foreach (name; names)"
  '';

  nativeBuildInputs = [
    makeWrapper
    which
    installShellFiles
  ] ++ lib.optionals (!bootstrap) [
    dmdBootstrap
  ] ++ lib.optionals (lib.versionOlder version "2.088.0") [
    git
  ];

  buildInputs = [
    curl
    tzdata
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  nativeCheckInputs = [
    gdb
  ] ++ lib.optionals (lib.versionOlder version "2.089.0") [
    unzip
  ];

  buildFlags =
    if bootstrap then [
      "-fposix.mak"
      "CXXFLAGS+=-Wno-format-security"
      "CXXFLAGS+=-DTARGET_LINUX"
    ] else [
      "BUILD=release"
      "ENABLE_RELEASE=1"
      "PIC=1"
    ];

  # Build and install are based on http://wiki.dlang.org/Building_DMD
  buildPhase = ''
    runHook preBuild

    export buildJobs=$NIX_BUILD_CORES
    [ -z "$enableParallelBuilding" ] && buildJobs=1
  '' + lib.optionalString bootstrap ''
    make -C dmd -j$buildJobs $buildFlags
  '' + lib.optionalString (!bootstrap) ''
    ${dmdBin} -run dmd/compiler/src/build.d -j$buildJobs $buildFlags \
      HOST_DMD=${dmdBin}
    make -C dmd/druntime -j$buildJobs DMD=${pathToDmd} $buildFlags
    echo ${tzdata}/share/zoneinfo/ > TZDatabaseDirFile
    echo ${lib.getLib curl}/lib/libcurl${stdenv.hostPlatform.extensions.sharedLibrary} \
      > LibcurlPathFile
    make -C phobos -j$buildJobs $buildFlags \
      DMD=${pathToDmd} DFLAGS="-version=TZDatabaseDir -version=LibcurlPath -J$PWD"

    runHook postBuild
  '';

  doCheck = !bootstrap;

  # many tests are disabled because they are failing

  # NOTE: Purity check is disabled for checkPhase because it doesn't fare well
  # with the DMD linker. See https://github.com/NixOS/nixpkgs/issues/97420
  checkPhase = ''
    runHook preCheck

    export checkJobs=$NIX_BUILD_CORES
    [ -z "$enableParallelChecking" ] && checkJobs=1

    CC=$CXX HOST_DMD=${pathToDmd} NIX_ENFORCE_PURITY= \
      ${dmdBin} -i -Idmd/compiler/test \
      -run dmd/compiler/test/run.d -j$checkJobs

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
    cp -r {${druntimeImport}/*,phobos/{std,etc}} $out/include/dmd/

    mkdir $out/lib
    cp phobos/generated/${osname}/release/${bits}/libphobos2.* $out/lib/

    wrapProgram $out/bin/dmd \
      --prefix PATH : "${targetPackages.stdenv.cc}/bin" \
      --set-default CC "${targetPackages.stdenv.cc}/bin/cc"

    substitute ${dmdConfFile} ${dmdConfPath} --subst-var out

    runHook postInstall
  '';

  preFixup = ''
    find $out/bin -type f -exec ${removeReferencesTo}/bin/remove-references-to -t ${dmdBin} '{}' +
  '';

  disallowedReferences = lib.optional (!bootstrap) dmdBootstrap;

  passthru = {
    bootstrap = dmdBootstrap;
  };

  meta = with lib; {
    description = "Official reference compiler for the D language";
    homepage = "https://dlang.org/";
    changelog = "https://dlang.org/changelog/${finalAttrs.version}.html";
    # Everything is now Boost licensed, even the backend.
    # https://github.com/dlang/dmd/pull/6680
    license = licenses.boost;
    mainProgram = "dmd";
    maintainers = with maintainers; [ lionello dukc jtbx ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    # ld: section __DATA/__thread_bss has type zero-fill but non-zero file offset file '/private/tmp/nix-build-dmd-2.109.1.drv-0/.rdmd-301/rdmd-build.d-A1CF043A7D87C5E88A58F3C0EF5A0DF7/objs/build.o' for architecture x86_64
    # clang-16: error: linker command failed with exit code 1 (use -v to see invocation)
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
})
