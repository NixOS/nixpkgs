{ stdenv
, fetchFromGitHub
, gettext
, libxml2
, pkgconfig
, gtk3
, granite
, gnome3
, cmake
, ninja
, vala
, elementary-cmake-modules
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "regextester-${version}";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "artemanufrij";
    repo = "regextester";
    rev = version;
    sha256 = "07shdm10dc7jz2hka5dc51yp81a0dgc47nmkrp6fs6r9wqx0j30n";
  };

  XDG_DATA_DIRS = stdenv.lib.concatStringsSep ":" [
    "${granite}/share"
    "${gnome3.libgee}/share"
  ];

  nativeBuildInputs = [
    pkgconfig
    wrapGAppsHook
    vala
    cmake
    ninja
    gettext
    libxml2
    elementary-cmake-modules
  ];
  buildInputs = [
    gtk3
    granite
    gnome3.libgee
  ];

  meta = with stdenv.lib; {
    description = "A desktop application to test regular expressions interactively";
    homepage = https://github.com/artemanufrij/regextester;
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
