{ lib, stdenv, fetchFromGitHub, libusb1, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "rogauracore";
  version = "1.6.0";

  src = fetchFromGitHub {
    url = "https://github.com/wroberts/rogauracore";
    rev = "a872431a59e47c1ab0b2a523e413723bdcd93a6e";
    hash = "sha256-SeG6B9ksWH4/UjLq5yPncVMTYjqMOxOh2R3N0q29fQ0=";
  };

  buildInputs = [
    libusb1
    autoreconfHook
  ];

  configurePhase = ''
    runHook preConfigure

    autoreconf -i
    ./configure

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 rogauracore $out/bin/

    runHook postInstall
  '';

  meta = {
    description = "Linux-compatible open-source libusb implementation similar to the ROG Aura Core software";
    homepage = "https://github.com/wroberts/rogauracore";
    maintainers = with lib.maintainers; [ truebad0ur ];
    licenses = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
