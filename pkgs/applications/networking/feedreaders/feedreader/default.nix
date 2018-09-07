{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, vala_0_40, gettext, python3
, appstream-glib, desktop-file-utils, glibcLocales, wrapGAppsHook
, curl, glib, gnome3, gst_all_1, json-glib, libnotify, libsecret, sqlite
}:

let
  pname = "FeedReader";
  version = "2.2";
in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "jangernert";
    repo = pname;
    rev = "v" + version;
    sha256 = "17588hsa7xv92ba55kmbyvnijypp373yrly48kbc391wadp1z939";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig vala_0_40 gettext appstream-glib desktop-file-utils
    python3 glibcLocales wrapGAppsHook
  ];

  buildInputs = [
    curl glib json-glib libnotify libsecret sqlite
  ] ++ (with gnome3; [
    gtk libgee libpeas libsoup rest webkitgtk gnome-online-accounts
    gsettings-desktop-schemas
  ]) ++ (with gst_all_1; [
    gstreamer gst-plugins-base gst-plugins-good
  ]);

  # TODO: fix https://github.com/NixOS/nixpkgs/issues/39547
  LIBRARY_PATH = stdenv.lib.makeLibraryPath [ curl ];

  # vcs_tag function fails with UnicodeDecodeError
  LC_ALL = "en_US.UTF-8";

  postPatch = ''
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    description = "A modern desktop application designed to complement existing web-based RSS accounts.";
    homepage = https://jangernert.github.io/FeedReader/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}
