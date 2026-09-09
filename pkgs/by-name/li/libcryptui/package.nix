{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  gettext,
  pkg-config,
  intltool,
  glib,
  gnome,
  gtk3,
  gtk3-x11,
  gtk3' ? if stdenv.hostPlatform.isDarwin then gtk3-x11 else gtk3,
  gtk-doc,
  gnupg,
  gpgme,
  dbus-glib,
  gcr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcryptui";
  version = "3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/libcryptui/${lib.versions.majorMinor finalAttrs.version}/libcryptui-${finalAttrs.version}.tar.xz";
    sha256 = "0rh8wa5k2iwbwppyvij2jdxmnlfjbna7kbh2a5n7zw4nnjkx3ski";
  };

  patches = (lib.map fetchurl (import ./debian-patches.nix)) ++ [
    # Fix build with gpgme 2.0
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/libcryptui/-/raw/1-3.12.2+r71+ged4f890e-2/gpgme-2.0.patch";
      hash = "sha256-yftIixqVGUqn/VP0tfzPnhLPI7A/m61kVY5P1NDTIqQ=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    dbus-glib # dbus-binding-tool
    gtk3' # AM_GLIB_GNU_GETTEXT
    gtk-doc
    intltool
    autoreconfHook
  ];
  buildInputs = [
    glib
    gtk3'
    gnupg
    gpgme
    dbus-glib
    gcr
  ];
  propagatedBuildInputs = [ dbus-glib ];

  env.GNUPG = lib.getExe gnupg;
  env.GPGME_CONFIG = lib.getExe' (lib.getDev gpgme) "gpgme-config";

  enableParallelBuilding = true;

  preAutoreconf = ''
    # error: possibly undefined macro: AM_NLS
    cp ${gettext}/share/gettext/m4/nls.m4 m4
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libcryptui";
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "Interface components for OpenPGP";
    mainProgram = "seahorse-daemon";
    homepage = "https://gitlab.gnome.org/GNOME/libcryptui";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    # ImportError: lib/gobject-introspection/giscanner/_giscanner.cpython-312-x86_64-linux-gnu.so
    # cannot open shared object file: No such file or directory
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
})
