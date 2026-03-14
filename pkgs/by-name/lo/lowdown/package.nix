{
  lib,
  stdenv,
  fetchurl,
  fixDarwinDylibNames,
  which,
  dieHook,
  bmake,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableDarwinSandbox ? true,
  # for passthru.tests
  nix,
  lowdown-unsandboxed,
}:

stdenv.mkDerivation rec {
  pname = "lowdown${
    lib.optionalString (stdenv.hostPlatform.isDarwin && !enableDarwinSandbox) "-unsandboxed"
  }";
  version = "3.0.0";

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "94e97234d598382c3c3dc27f9bfdb3a3a2fcf7dbb6a8df3c85ee09f27f792449034a41d49d9cfd3d8450d2de01b8562c20c3d120e65c81af4d7d6c9454119e93";
  };

  # https://github.com/kristapsdz/lowdown/pull/171
  patches = [ ./fix-cygwin-build.patch ];

  nativeBuildInputs = [
    which
    dieHook
    bmake # Uses FreeBSD's dialect
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  # The Darwin sandbox calls fail inside Nix builds, presumably due to
  # being nested inside another sandbox.
  preConfigure = lib.optionalString (stdenv.hostPlatform.isDarwin && !enableDarwinSandbox) ''
    echo 'HAVE_SANDBOX_INIT=0' > configure.local
  '';

  configurePhase = ''
    runHook preConfigure
    ./configure PREFIX=''${!outputDev} \
                BINDIR=''${!outputBin}/bin \
                LIBDIR=''${!outputLib}/lib \
                MANDIR=''${!outputMan}/share/man
    runHook postConfigure
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isCygwin "-D_GNU_SOURCE";
  # Fix rpath change on darwin to avoid failure like:
  #     error: install_name_tool: changing install names or
  #     rpaths can't be redone for: liblowdown.1.dylib (for architecture
  #     arm64) because larger
  #   https://github.com/NixOS/nixpkgs/pull/344532#issuecomment-238475791
  env.NIX_CFLAGS_LINK = lib.optionalString stdenv.hostPlatform.isDarwin "-headerpad_max_install_names";

  makeFlags = [
    "bins" # prevents shared object from being built unnecessarily
  ]
  ++ lib.optionals stdenv.hostPlatform.isCygwin [
    "EXESUFFIX=.exe"
    "LINKER_SOSUFFIX=dll"
    "LIB_SO=cyglowdown.dll"
    "IMPLIB=liblowdown.dll.a"
    "LDFLAGS=-Wl,--out-implib,liblowdown.dll.a"
  ];

  installTargets = [
    "install"
  ]
  ++ lib.optionals enableShared [
    "install_shared"
  ]
  ++ lib.optionals enableStatic [
    "install_static"
  ];

  doInstallCheck = !stdenv.hostPlatform.isDarwin || !enableDarwinSandbox;
  installCheckPhase = ''
    runHook preInstallCheck

    echo '# TEST' > test.md
    $out/bin/lowdown test.md

    runHook postInstallCheck
  '';

  doCheck = !stdenv.hostPlatform.isDarwin || !enableDarwinSandbox;
  checkTarget = "regress";

  passthru.tests = {
    # most important consumers in nixpkgs
    inherit nix lowdown-unsandboxed;
  };

  meta = {
    homepage = "https://kristaps.bsd.lv/lowdown/";
    description = "Simple markdown translator";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.sternenseemann ];
    platforms = lib.platforms.unix;
  };
}
