{ stdenv, fetchFromGitHub, cmake, x11, libX11, libXi, libXtst, libXrandr
, xinput, curl, openssl, unzip }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "synergy-${version}";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "synergy";
    repo = "synergy";
    rev = "v${version}-stable";
    sha256 = "0pxj0qpnsaffpaxik8vc5rjfinmx8ab3b2lssrxkfbs7isskvs33";
  };

  postPatch = ''
    ${unzip}/bin/unzip -d ext/gmock-1.6.0 ext/gmock-1.6.0.zip
    ${unzip}/bin/unzip -d ext/gtest-1.6.0 ext/gtest-1.6.0.zip
  '';

  buildInputs = [
    cmake x11 libX11 libXi libXtst libXrandr xinput curl openssl
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ../bin/synergyc $out/bin
    cp ../bin/synergys $out/bin
    cp ../bin/synergyd $out/bin
  '';

  doCheck = true;
  checkPhase = "../bin/unittests";

  meta = {
    description = "Share one mouse and keyboard between multiple computers";
    homepage = "http://synergy-project.org/";
    license = licenses.gpl2;
    maintainers = [ maintainers.aszlig ];
    platforms = platforms.all;
  };
}
