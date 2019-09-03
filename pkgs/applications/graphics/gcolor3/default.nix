{ stdenv, fetchFromGitLab, meson, ninja, gettext, pkgconfig, libxml2, gtk3, hicolor-icon-theme, wrapGAppsHook }:

let
  version = "2.3.1";
in stdenv.mkDerivation {
  pname = "gcolor3";
  inherit version;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "gcolor3";
    rev = "v${version}";
    sha256 = "10cfzlkflwkb7f51rnrxmgxpfryh1qzvqaydj6lffjq9zvnhigg7";
  };

  nativeBuildInputs = [ meson ninja gettext pkgconfig libxml2 wrapGAppsHook ];

  buildInputs = [ gtk3 hicolor-icon-theme ];

  postPatch = ''
    chmod +x meson_install.sh # patchShebangs requires executable file
    patchShebangs meson_install.sh
  '';

  meta = with stdenv.lib; {
    description = "A simple color chooser written in GTK3";
    homepage = https://www.hjdskes.nl/projects/gcolor3/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
