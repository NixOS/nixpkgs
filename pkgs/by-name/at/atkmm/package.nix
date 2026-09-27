{
  lib,
  stdenv,
  fetchurl,
  atk,
  glibmm_2_4,
  pkg-config,
  gnome,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atkmm";
  version = "2.28.5";

  src = fetchurl {
    url = "mirror://gnome/sources/atkmm/${lib.versions.majorMinor finalAttrs.version}/atkmm-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-rkSRkqWColgqleBgKxXXkrvWOeg2M5uB75FqqHVArFw=";
  };

  outputs = [
    "out"
    "dev"
  ];

  propagatedBuildInputs = [
    atk
    glibmm_2_4
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    python3
    ninja
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "atkmm";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = {
    description = "C++ wrappers for ATK accessibility toolkit";
    license = lib.licenses.lgpl21Plus;
    homepage = "https://gtkmm.org";
    platforms = lib.platforms.unix;
  };
})
