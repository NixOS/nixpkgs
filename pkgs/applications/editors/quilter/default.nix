{ stdenv, fetchFromGitHub, pkgconfig, meson, ninja, python3, vala
, gtk3, desktop-file-utils, gtksourceview, webkitgtk, gtkspell3, pantheon
, libgee, discount, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "quilter";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "1jmgnmpalnl3261wifk0mqa9viag6yvlrycgzqalmnrm1b20pyg4";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    vala
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    discount
    gtk3
    gtksourceview
    gtkspell3
    libgee
    pantheon.elementary-icon-theme
    pantheon.granite
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Focus on your writing - designed for elementary OS";
    homepage = https://github.com/lainsce/quilter;
    license = licenses.gpl2Plus;
    maintainers = pantheon.maintainers;
    platforms = platforms.linux;
  };
}
