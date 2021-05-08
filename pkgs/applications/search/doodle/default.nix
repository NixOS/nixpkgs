{ lib, stdenv, fetchurl, libextractor, gettext }:

stdenv.mkDerivation rec {
  name = "doodle-0.7.2";

  buildInputs = [ libextractor gettext ];

  src = fetchurl {
    url = "https://grothoff.org/christian/doodle/download/${name}.tar.gz";
    sha256 = "sha256-dtRPfUjhBNgN+5zHMYmszISmBv1+K6yjKsbQBiAXWRA=";
  };

  meta = {
    homepage = "https://grothoff.org/christian/doodle/";
    description = "Tool to quickly index and search documents on a computer";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}
