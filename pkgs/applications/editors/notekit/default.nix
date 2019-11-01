{ stdenv, fetchFromGitHub, wrapGAppsHook
, cmake, pkgconfig
, gtkmm3, gtksourceviewmm, gtksourceview3
, jsoncpp
}:

stdenv.mkDerivation rec {
  pname = "notekit-unstable";
  version = "6c7aa1c37b494ba10a33ed0709a902b6f56ea76c";

  src = fetchFromGitHub {
    owner = "blackhole89";
    repo = "notekit";
    rev = version;
    sha256 = "0dsnkdjhs0qpp4v075xnjb5jjmccp84bv5rl5c8r5790rply6yc7";
  };

  nativeBuildInputs = [
    pkgconfig cmake wrapGAppsHook
    #cmake ninja libxml2
    #python3 perl itstool desktop-file-utils
  ];

  buildInputs = [
    gtkmm3 gtksourceviewmm
    jsoncpp gtksourceview3
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/blackhole89/notekit";
    description = "A GTK3 hierarchical markdown notetaking application with tablet support";
    maintainers = [];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
