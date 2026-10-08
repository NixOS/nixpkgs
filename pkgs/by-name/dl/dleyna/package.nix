{
  stdenv,
  lib,
  docutils,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gupnp_1_6,
  gupnp-av,
  gupnp-dlna,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dleyna";
  version = "0.8.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "dLeyna";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ti4yF8sALpWyrdQTt/jVrMKQ4PLhakEi620fJNMxT0c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    docutils
    pkg-config
  ];

  buildInputs = [
    gupnp_1_6
    gupnp-dlna
    gupnp-av
    gupnp-dlna
  ];

  mesonFlags = [
    # Sphinx docs not installed, do not depend on sphinx
    "-Ddocs=false"
  ];

  meta = {
    description = "Library of utility functions that are used by the higher level dLeyna";
    homepage = "https://gitlab.gnome.org/World/dLeyna";
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21Only;
  };
})
