{ lib, stdenv, fetchFromGitHub, garmintools, libgcrypt, libusb-compat-0_1, pkg-config, tinyxml, zlib }:

stdenv.mkDerivation rec {
  pname = "garmin-plugin";
  version = "0.3.26";

  src = fetchFromGitHub {
    owner = "adiesner";
    repo = "GarminPlugin";
    rev = "V${version}";
    sha256 = "sha256-l0WAbEsQl1dCADf5gTepYjsA1rQCJMLcrTxRR4PfUus=";
  };

  preConfigure = ''
    cd src
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ garmintools libusb-compat-0_1 libgcrypt tinyxml zlib ];

  configureFlags = [
    "--with-libgcrypt-prefix=${libgcrypt.dev}"
    "--with-garmintools-incdir=${garmintools}/include"
    "--with-garmintools-libdir=${garmintools}/lib"
  ];

  installPhase = ''
    mkdir -p $out/lib/mozilla/plugins
    cp npGarminPlugin.so $out/lib/mozilla/plugins
  '';

  meta = with lib; {
    homepage = "https://adiesner.github.io/GarminPlugin/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
