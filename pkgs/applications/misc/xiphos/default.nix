{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  appstream-glib,
  biblesync,
  cmake,
  dbus-glib,
  desktop-file-utils,
  docbook2x,
  docbook_xml_dtd_412,
  enchant2,
  glib,
  gtk3,
  gtkhtml,
  icu,
  intltool,
  isocodes,
  itstool,
  libuuid,
  libxslt,
  minizip,
  pkg-config,
  sword,
  webkitgtk,
  wrapGAppsHook3,
  yelp-tools,
  zip,
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

  patches = [
    # GLIB_VERSION_MIN_REQUIRED is not defined.
    # https://github.com/crosswire/xiphos/issues/1083#issuecomment-820304874
    (fetchpatch {
      name = "xiphos-glibc.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/xiphos-glibc.patch?h=xiphos&id=bb816f43ba764ffac1287ab1e2a649c2443e3ce8";
      sha256 = "he3U7phU2/QCrZidHviupA7YwzudnQ9Jbb8eMZw6/ck=";
      extraPrefix = "";
    })

    # Fix D-Bus build
    # https://github.com/crosswire/xiphos/pull/1103
    ./0001-Add-dbus-glib-dependency-to-main.patch
  ];

  nativeBuildInputs = [
    appstream-glib # for appstream-util
    cmake
    desktop-file-utils # for desktop-file-validate
    docbook2x
    docbook_xml_dtd_412
    intltool
    itstool
    libxslt
    pkg-config
    wrapGAppsHook3
    yelp-tools # for yelp-build
    zip # for building help epubs
  ];

  buildInputs = [
    biblesync
    dbus-glib
    enchant2
    glib
    gtk3
    gtkhtml
    icu
    isocodes
    libuuid
    minizip
    sword
    webkitgtk
  ];

  cmakeFlags = [
    # WebKit-based editor does not build.
    "-DGTKHTML=ON"
  ];

  preConfigure = ''
    # The build script won't continue without the version saved locally.
    echo "${version}" > cmake/source_version.txt

    export SWORD_HOME=${sword};
  '';

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
