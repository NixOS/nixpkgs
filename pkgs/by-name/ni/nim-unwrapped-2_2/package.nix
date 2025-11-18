# When updating this package please check that all other versions of Nim
# evaluate because they reuse definitions from the latest compiler.
{
  lib,
  stdenv,
  fetchurl,
  boehmgc,
  openssl,
  pcre,
  readline,
  sqlite,
  darwin,
}:

let
  parseCpu =
    platform:
    with platform;
    # Derive a Nim CPU identifier
    if isAarch32 then
      "arm"
    else if isAarch64 then
      "arm64"
    else if isAlpha then
      "alpha"
    else if isAvr then
      "avr"
    else if isMips && is32bit then
      "mips"
    else if isMips && is64bit then
      "mips64"
    else if isMsp430 then
      "msp430"
    else if isPower && is32bit then
      "powerpc"
    else if isPower && is64bit then
      "powerpc64"
    else if isRiscV && is64bit then
      "riscv64"
    else if isSparc then
      "sparc"
    else if isx86_32 then
      "i386"
    else if isx86_64 then
      "amd64"
    else
      throw "no Nim CPU support known for ${config}";

  parseOs =
    platform:
    with platform;
    # Derive a Nim OS identifier
    if isAndroid then
      "Android"
    else if isDarwin then
      "MacOSX"
    else if isFreeBSD then
      "FreeBSD"
    else if isGenode then
      "Genode"
    else if isLinux then
      "Linux"
    else if isNetBSD then
      "NetBSD"
    else if isNone then
      "Standalone"
    else if isOpenBSD then
      "OpenBSD"
    else if isWindows then
      "Windows"
    else if isiOS then
      "iOS"
    else
      throw "no Nim OS support known for ${config}";

  parsePlatform = p: {
    cpu = parseCpu p;
    os = parseOs p;
  };

  nimHost = parsePlatform stdenv.hostPlatform;
  nimTarget = parsePlatform stdenv.targetPlatform;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "nim-unwrapped";
  version = "2.2.4";
  strictDeps = true;

  src = fetchurl {
    url = "https://nim-lang.org/download/nim-${finalAttrs.version}.tar.xz";
    hash = "sha256-+CtBl1D8zlYfP4l6BIaxgBhoRddvtdmfJIzhZhCBicc=";
  };

  buildInputs = [
    boehmgc
    openssl
    pcre
    readline
    sqlite
  ];

  patches = [
    ./NIM_CONFIG_DIR.patch
    # Override compiler configuration via an environmental variable

    ./nixbuild.patch
    # Load libraries at runtime by absolute path

    ./extra-mangling-2.patch
    # Mangle store paths of modules to prevent runtime dependence.

    ./openssl.patch
    # dlopen is widely used by Python, Ruby, Perl, ... what you're really telling me here is that your OS is fundamentally broken. That might be news for you, but it isn't for me.
  ];

  configurePhase =
    let
      bootstrapCompiler = stdenv.mkDerivation {
        pname = "nim-bootstrap";
        inherit (finalAttrs) version src preBuild;
        enableParallelBuilding = true;
        installPhase = ''
          runHook preInstall
          install -Dt $out/bin bin/nim
          runHook postInstall
        '';
      };
    in
    ''
      runHook preConfigure
      cp ${bootstrapCompiler}/bin/nim bin/
      echo 'define:nixbuild' >> config/nim.cfg
      runHook postConfigure
    '';

  kochArgs = [
    "--cpu:${nimHost.cpu}"
    "--os:${nimHost.os}"
    "-d:release"
    "-d:useGnuReadline"
  ]
  ++ lib.optional (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isLinux) "-d:nativeStacktrace";

  preBuild = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    substituteInPlace makefile \
      --replace "aarch64" "arm64"
  '';

  buildPhase = ''
    runHook preBuild
    local HOME=$TMPDIR
    ./bin/nim c --parallelBuild:$NIX_BUILD_CORES koch
    ./koch boot $kochArgs --parallelBuild:$NIX_BUILD_CORES
    ./koch toolsNoExternal $kochArgs --parallelBuild:$NIX_BUILD_CORES
    ./bin/nim js -d:release tools/dochack/dochack.nim
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin bin/*
    ln -sf $out/nim/bin/nim $out/bin/nim
    ln -sf $out/nim/lib $out/lib
    ./install.sh $out
    cp -a tools dist $out/nim/
    runHook postInstall
  '';

  passthru = {
    inherit nimHost nimTarget;
  };

  meta = with lib; {
    description = "Statically typed, imperative programming language";
    homepage = "https://nim-lang.org/";
    license = licenses.mit;
    mainProgram = "nim";
    teams = [ lib.teams.nim ];
  };

})
