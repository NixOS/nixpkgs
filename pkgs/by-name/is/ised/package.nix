{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "ised";
  version = "2.7.1";
  src = fetchurl {
    url = "mirror://sourceforge/project/ised/ised-${version}.tar.bz2";
    sha256 = "0fhha61whkkqranqdxg792g0f5kgp5m3m6z1iqcvjh2c34rczbmb";
  };

  meta = with lib; {
    description = "Numeric sequence editor";
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; linux;
    license = licenses.gpl3Plus;
    mainProgram = "ised";
  };
}
