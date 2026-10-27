{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsigc++";
  version = "2.12.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "mirror://gnome/sources/libsigc++/${lib.versions.majorMinor finalAttrs.version}/libsigc++-${finalAttrs.version}.tar.xz";
    hash = "sha256-qdvuMjNR0Qm3ruB0qcuJyj57z4rY7e8YUfTPNZvVCEM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libsigc++";
      attrPath = "libsigcxx_2_0";
      versionPolicy = "odd-unstable";
      freeze = "2.99.1";
    };
  };

  meta = {
    homepage = "https://libsigcplusplus.github.io/libsigcplusplus/";
    description = "Typesafe callback system for standard C++";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
})
