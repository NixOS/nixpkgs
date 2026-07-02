{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnum4,
  glib,
  libsigcxx,
  gnome,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glibmm";
  version = "2.66.8";

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${lib.versions.majorMinor finalAttrs.version}/glibmm-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZPEdO5WiTiqNQWbs/1GHMPeezCciLvQfr3x+A0D8kyk=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    gnum4
    glib # for glib-compile-schemas
  ];
  propagatedBuildInputs = [
    glib
    libsigcxx
  ];

  doCheck = false; # fails. one test needs the net, another /etc/fstab

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "glibmm";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = {
    description = "C++ interface to the GLib library";

    homepage = "https://gtkmm.org/";

    license = lib.licenses.lgpl2Plus;

    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
  };
})
