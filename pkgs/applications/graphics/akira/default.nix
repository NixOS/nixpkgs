{ stdenv
, lib
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, meson
, ninja
, pantheon
, pkg-config
, python3
, vala
, vala-lint
, wrapGAppsHook
, cairo
, glib
, goocanvas3
, gtk3
, gtksourceview3
, json-glib
, libarchive
, libgee
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "akira";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "akiraux";
    repo = "Akira";
    rev = "v${version}";
    sha256 = "1zbb2bsc6v2rwrbigbkgrzfjmlj96s3ri73zbdcyqg4p08v1w4l6";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    vala-lint
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    glib
    goocanvas3
    pantheon.granite
    gtk3
    gtksourceview3
    json-glib
    libarchive
    libgee
    libxml2
  ];

  mesonFlags = [ "-Dprofile=default" ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  meta = with lib; {
    description = "Native Linux Design application built in Vala and GTK";
    homepage = "https://github.com/akiraux/Akira";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne neonfuz ] ++ pantheon.maintainers;
    platforms = platforms.linux;
  };
}
