{
  lib,
  stdenv,
  fetchFromGitHub,
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
    rev = "v${finalAttrs.version}";
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

  passthru.tests = finalAttrs.finalPackage.overrideAttrs (_: {
    configureFlags = [ "--with-tests" ];
    doCheck = true;
  });

  meta = with lib; {
    homepage = "https://fukuchi.org/works/qrencode/";
    description = "C library for encoding data in a QR Code symbol";
    longDescription = ''
      Libqrencode is a C library for encoding data in a QR Code symbol,
      a kind of 2D symbology that can be scanned by handy terminals
      such as a mobile phone with CCD.
    '';
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.all;
    mainProgram = "qrencode";
  };
})
