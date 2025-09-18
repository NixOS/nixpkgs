{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  libpng,
  libiconv,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qrencode";
  version = "4.1.1";

  outputs = [
    "bin"
    "out"
    "man"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "fukuchi";
    repo = "libqrencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nbrmg9SqCqMrLE7WCfNEzMV/eS9UVCKCrjBrGMzAsLk";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libiconv
    libpng
  ];

  doCheck = false;

  checkPhase = ''
    runHook preCheck

    pushd tests
    ./test_basic.sh
    popd

    runHook postCheck
  '';

  passthru = {
    tests = finalAttrs.finalPackage.overrideAttrs {
      configureFlags = [ "--with-tests" ];
      doCheck = true;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://fukuchi.org/works/qrencode/";
    description = "C library and command line tool for encoding data in a QR Code symbol";
    longDescription = ''
      Libqrencode is a C library for encoding data in a QR Code symbol,
      a kind of 2D symbology that can be scanned by handy terminals
      such as a smartphone.

      The library also contains qrencode, a command-line utility to output
      QR Code images in various formats.
    '';
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.mdaniels5757 ];
    platforms = lib.platforms.all;
    mainProgram = "qrencode";
  };
})
