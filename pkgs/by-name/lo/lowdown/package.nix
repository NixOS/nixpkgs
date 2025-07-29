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
}:

stdenv.mkDerivation rec {
  pname = "lowdown${
    lib.optionalString (stdenv.hostPlatform.isDarwin && !enableDarwinSandbox) "-unsandboxed"
  }";
  version = "2.0.2";

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    hash = "sha512-cfzhuF4EnGmLJf5EGSIbWqJItY3npbRSALm+GarZ7SMU7Hr1xw0gtBFMpOdi5PBar4TgtvbnG4oRPh+COINGlA==";
  };

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

  # Fix rpath change on darwin to avoid failure like:
  #     error: install_name_tool: changing install names or
  #     rpaths can't be redone for: liblowdown.1.dylib (for architecture
  #     arm64) because larger
  #   https://github.com/NixOS/nixpkgs/pull/344532#issuecomment-238475791
  env.NIX_CFLAGS_LINK = lib.optionalString stdenv.hostPlatform.isDarwin "-headerpad_max_install_names";

  makeFlags = [
    "bins" # prevents shared object from being built unnecessarily
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

  postInstall =
    let
      soVersion = "2";
    in

    # Check that soVersion is up to date even if we are not on darwin
    lib.optionalString (enableShared && !stdenv.hostPlatform.isDarwin) ''
      test -f $lib/lib/liblowdown.so.${soVersion} || \
        die "postInstall: expected $lib/lib/liblowdown.so.${soVersion} is missing"
    ''
    # Fix lib extension so that fixDarwinDylibNames detects it, see
    # <https://github.com/kristapsdz/lowdown/issues/87#issuecomment-1532243650>.
    + lib.optionalString (enableShared && stdenv.hostPlatform.isDarwin) ''
      darwinDylib="$lib/lib/liblowdown.${soVersion}.dylib"
      mv "$lib/lib/liblowdown.so.${soVersion}" "$darwinDylib"

      # Make sure we are re-creating a symbolic link here
      test -L "$lib/lib/liblowdown.so" || \
        die "postInstall: expected $lib/lib/liblowdown.so to be a symlink"
      ln -s "$darwinDylib" "$lib/lib/liblowdown.dylib"
      rm "$lib/lib/liblowdown.so"
    '';

  doInstallCheck = true;

  installCheckPhase = lib.optionalString (!stdenv.hostPlatform.isDarwin || !enableDarwinSandbox) ''
    runHook preInstallCheck

    echo '# TEST' > test.md
    $out/bin/lowdown test.md

    runHook postInstallCheck
  '';

  doCheck = true;
  checkTarget = "regress";

  passthru.tests = {
    # most important consumer in nixpkgs
    inherit nix;
  };

  meta = with lib; {
    homepage = "https://kristaps.bsd.lv/lowdown/";
    description = "Simple markdown translator";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
}
