{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnum4,
  glib,
  libsigcxx30,
  gnome,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glibmm";
  version = "2.88.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${lib.versions.majorMinor finalAttrs.version}/glibmm-${finalAttrs.version}.tar.xz";
    hash = "sha256-wTn5YrFXXIgnzTnRrCG3o2e+O9oUCcDH4hopCQ83FQY=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    gnum4
    glib # for glib-compile-schemas
  ];

  propagatedBuildInputs = [
    glib
    libsigcxx30
  ];

  doCheck = false; # fails. one test needs the net, another /etc/fstab

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "glibmm";
      attrPath = "glibmm_2_68";
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "C++ interface to the GLib library";
    homepage = "https://gtkmm.org/";
    license = lib.licenses.lgpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
  };
})
