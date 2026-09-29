{
  dbus-glib,
  fetchFromGitHub,
  file,
  glib,
  gobject-introspection,
  intltool,
  json-glib,
  lib,
  pkg-config,
  stdenv,
  vala,
}:
# This is directly based on ../../li/libdbusmenu .
stdenv.mkDerivation (finalAttrs: {
  pname = "libdbusmenu-glib";
  version = "16.04.0-jetbrains-fork-2022-05-18";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jetbrains";
    repo = "libdbusmenu";
    rev = "d8a49303f908a272e6670b7cee65a2ba7c447875";
    hash = "sha256-u87ZgbfeCPJ0qG8gsom3gFaZxbS5NcHEodb0EVakk60=";
  };

  nativeBuildInputs = [
    vala
    pkg-config
    intltool
    gobject-introspection
  ];

  buildInputs = [
    glib
    dbus-glib
    json-glib
  ];

  patches = [
    ./requires-glib.patch
  ];

  postPatch = ''
    for f in {configure,ltmain.sh,m4/libtool.m4}; do
      substituteInPlace $f \
        --replace /usr/bin/file ${file}/bin/file
    done
  '';

  preConfigure = ''
    export HAVE_VALGRIND_TRUE="#"
    export HAVE_VALGRIND_FALSE=""
  '';

  configureFlags = [
    "CFLAGS=-Wno-error"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--disable-gtk"
    "--disable-dumper"
    "--disable-scrollkeeper"
    # jb:
    "--enable-static"
  ];

  doCheck = false;

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=\${TMPDIR}"
    "typelibdir=${placeholder "out"}/lib/girepository-1.0"
  ];

  postInstall = ''
    mkdir -p $out/lib
    cp libdbusmenu-glib/.libs/libdbusmenu-glib.a $out/lib
  '';

  meta = {
    description = "Library for passing menu structures across DBus";
    homepage = "https://launchpad.net/dbusmenu";
    license = with lib.licenses; [
      gpl3
      lgpl21
      lgpl3
    ];
    pkgConfigModules = [
      "dbusmenu-glib-0.4"
      "dbusmenu-jsonloader-0.4"
    ];
    platforms = lib.platforms.unix;
  };
})
