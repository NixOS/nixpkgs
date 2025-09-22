{
  lib,
  stdenv,
  fetchurl,
  libextractor,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "doodle";
  version = "0.7.3";

  buildInputs = [
    libextractor
    gettext
  ];

  src = fetchurl {
    url = "https://grothoff.org/christian/doodle/download/doodle-${version}.tar.gz";
    sha256 = "sha256-qodp2epYyolg38MNhBV+/NMLmfXjhsn2X9uKTUniv2s=";
  };

  meta = {
    homepage = "https://grothoff.org/christian/doodle/";
    description = "Tool to quickly index and search documents on a computer";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
    mainProgram = "doodle";
  };
}
