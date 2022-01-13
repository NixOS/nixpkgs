{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config
, python
, intltool
, docbook2x, docbook_xml_dtd_412, libxslt
, sword, clucene_core, biblesync
, gnome-doc-utils
, libgsf, gconf
, libglade, scrollkeeper
, webkitgtk
, dbus-glib, enchant, isocodes, libuuid, icu
, cmake, itstool, desktop-file-utils, appstream-glib, yelp-tools
, zip, minizip, pcre, libselinux, xorg, libsepol, libthai, libdatrie
, libxkbcommon, libepoxy, at-spi2-core, libsysprof-capture, sqlite
, libpsl, brotli, gtk2, glib, dbus, gtkhtml
, wrapGAppsHook
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

  nativeBuildInputs = [ pkg-config  wrapGAppsHook cmake itstool
    appstream-glib # for appstream-util
    desktop-file-utils # for desktop-file-validate
    yelp-tools # for yelp-build
  ];

  buildInputs = [
    python intltool docbook2x docbook_xml_dtd_412 libxslt
    sword clucene_core biblesync gnome-doc-utils libgsf gconf
    libglade scrollkeeper webkitgtk dbus-glib enchant isocodes libuuid icu
    zip minizip pcre xorg.libXdmcp libselinux libsepol libthai libdatrie
    libxkbcommon libepoxy at-spi2-core libsysprof-capture xorg.libXtst
    sqlite libpsl brotli gtk2 glib dbus dbus-glib gtkhtml
  ];

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
