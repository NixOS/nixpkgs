{ stdenv, fetchFromGitHub, fetchpatch, meson, ninja, pkgconfig, vala_0_40, gettext, python3
, appstream-glib, desktop-file-utils, glibcLocales, wrapGAppsHook
, curl, glib, gnome3, gst_all_1, json-glib, libnotify, libsecret, sqlite, gumbo
}:

stdenv.mkDerivation rec {
  pname = "feedreader";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "jangernert";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x5milynfa27zyv2jkzyi7ikkszrvzki1hlzv8c2wvcmw60jqb8n";
  };

  patches = [
    # See: https://github.com/jangernert/FeedReader/pull/842
    (fetchpatch {
      url = "https://github.com/jangernert/FeedReader/commit/f4ce70932c4ddc91783309708402c7c42d627455.patch";
      sha256 = "076fpjn973xg2m35lc6z4h7g5x8nb08sghg94glsqa8wh1ig2311";
    })
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig vala_0_40 gettext appstream-glib desktop-file-utils
    python3 glibcLocales wrapGAppsHook
  ];

  buildInputs = [
    curl glib json-glib libnotify libsecret sqlite gumbo
  ] ++ (with gnome3; [
    gtk libgee libpeas libsoup rest webkitgtk gnome-online-accounts
    gsettings-desktop-schemas
  ]) ++ (with gst_all_1; [
    gstreamer gst-plugins-base gst-plugins-good
  ]);

  # vcs_tag function fails with UnicodeDecodeError
  LC_ALL = "en_US.UTF-8";

  postPatch = ''
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    description = "A modern desktop application designed to complement existing web-based RSS accounts";
    homepage = https://jangernert.github.io/FeedReader/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}
