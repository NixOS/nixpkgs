{ lib
, stdenv
, fetchurl
, gettext
, pkg-config
, icu
}:

stdenv.mkDerivation rec {
  pname = "dwdiff";
  version = "2.1.4";

  src = fetchurl {
    url = "https://os.ghalkes.nl/dist/dwdiff-${version}.tar.bz2";
    sha256 = "sha256-3xb+xE3LRn1lpCRqQ2KPk3QZlsF3PpMLkMbd4i3Vjgo=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gettext
    icu
  ];

  meta = with lib; {
    description = "Front-end for the diff program that operates at the word level instead of the line level";
    homepage = "https://os.ghalkes.nl/dwdiff.html";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };

}
