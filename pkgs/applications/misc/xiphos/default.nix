{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, appstream-glib
, at-spi2-core
, biblesync
, brotli
, clucene_core
, cmake
, dbus
, dbus-glib
, desktop-file-utils
, docbook2x
, docbook_xml_dtd_412
, enchant
, gconf
, glib
, gnome-doc-utils
, gtk2
, gtkhtml
, icu
, intltool
, isocodes
, itstool
, libdatrie
, libepoxy
, libglade
, libgsf
, libpsl
, libselinux
, libsepol
, libsysprof-capture
, libthai
, libuuid
, libxkbcommon
, libxslt
, minizip
, pcre
, pkg-config
, python
, scrollkeeper
, sqlite
, sword
, webkitgtk
, wrapGAppsHook
, xorg
, yelp-tools
, zip
}:

stdenv.mkDerivation rec {
  pname = "xiphos";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "crosswire";
    repo = "xiphos";
    rev = version;
    hash = "sha256-H5Q+azE2t3fgu77C9DxrkeUCJ7iJz3Cc91Ln4dqLvD8=";
  };

  nativeBuildInputs = [
    appstream-glib
    cmake
    desktop-file-utils
    itstool
    pkg-config
    wrapGAppsHook
    yelp-tools
  ];

  buildInputs = [
    at-spi2-core
    biblesync
    brotli
    clucene_core
    dbus
    dbus-glib
    docbook2x
    docbook_xml_dtd_412
    enchant
    gconf
    glib
    gnome-doc-utils
    gtk2
    gtkhtml
    icu
    intltool
    isocodes
    libdatrie
    libepoxy
    libglade
    libgsf
    libpsl
    libselinux
    libsepol
    libsysprof-capture
    libthai
    libuuid
    libxkbcommon
    libxslt
    minizip
    pcre
    python
    scrollkeeper
    sqlite
    sword
    webkitgtk
    zip
  ]
  ++ (with xorg; [
    libXdmcp
    libXtst
  ]);

  cmakeFlags = [
    "-DDBUS=OFF"
    "-DGTKHTML=ON"
  ];

  preConfigure =  ''
    # The build script won't continue without the version saved locally.
    echo "${version}" > cmake/source_version.txt

    export CLUCENE_HOME=${clucene_core};
    export SWORD_HOME=${sword};
  '';

  patchFlags = [ "-p0" ];

  patches = [
    # GLIB_VERSION_MIN_REQUIRED is not defined.
    # https://github.com/crosswire/xiphos/issues/1083#issuecomment-820304874
    (fetchpatch {
      name ="xiphos-glibc.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/xiphos-glibc.patch?h=xiphos";
      sha256 = "sha256-0WadztJKXW2adqsDP8iSAYVShbdqHoDvP+aVJC0cQB0=";
    })
  ];

  meta = with lib; {
    description = "A GTK Bible study tool";
    longDescription = ''
      Xiphos (formerly known as GnomeSword) is a Bible study tool
      written for Linux, UNIX, and Windows using GTK, offering a rich
      and featureful environment for reading, study, and research using
      modules from The SWORD Project and elsewhere.
    '';
    homepage = "https://www.xiphos.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
