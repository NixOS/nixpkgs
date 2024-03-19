{ lib
, fetchurl
, stdenv
, undmg
}:

stdenv.mkDerivation rec {
  pname = "pika";
  version = "0.0.12";

  src = fetchurl {
    url = "https://github.com/superhighfives/${pname}/releases/download/${version}/Pika-${version}.dmg";
    sha256 = "sha256-hcP2bETEx9RQW43I9nvdRPi9lbWwKW6mhRx5H6RxhjM=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Pika.app";

  installPhase = ''
    mkdir -p "$out/Applications/Pika.app"
    cp -R . "$out/Applications/Pika.app"
  '';

  meta = with lib; {
    homepage = "https://superhighfives.com/pika";
    description = "An open-source colour picker app for macOS";
    platforms = platforms.darwin;
    license = licenses.mit;
    maintainers = with maintainers; [ arkivm ];
  };
}
