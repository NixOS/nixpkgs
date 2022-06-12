{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libdsk";
  version = "1.5.18";

  src = fetchurl {
    url = "https://www.seasip.info/Unix/LibDsk/${pname}-${version}.tar.gz";
    sha256 = "sha256-43HUMQ35nwOwaQP8F1vO7zFccxHrQqJhZ6D5zzYhB5A=";
  };

  meta = with lib; {
    description = "A library for accessing discs and disc image files";
    homepage = "http://www.seasip.info/Unix/LibDsk/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
