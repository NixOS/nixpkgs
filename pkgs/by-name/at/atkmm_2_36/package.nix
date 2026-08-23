{
  lib,
  stdenv,
  fetchurl,
  atk,
  glibmm_2_68,
  pkg-config,
  gnome,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atkmm";
  version = "2.36.4";

  src = fetchurl {
    url = "mirror://gnome/sources/atkmm/${lib.versions.majorMinor finalAttrs.version}/atkmm-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-Gc0HWO11LLifW/AiR2Y9+tCSbZNRmEog48bPfaYlUqw=";
  };

  outputs = [
    "out"
    "dev"
  ];

  propagatedBuildInputs = [
    atk
    glibmm_2_68
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "atkmm_2_36";
      packageName = "atkmm";
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "C++ wrappers for ATK accessibility toolkit";
    license = lib.licenses.lgpl21Plus;
    homepage = "https://gtkmm.org";
    platforms = lib.platforms.unix;
  };
})
