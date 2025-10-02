{
  lib,
  stdenv,
  fetchurl,
  guile,
  mosquitto,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-mqtt";
  version = "1.0.0";

  # building from git repo requires nyacc>=2.01.3
  src = fetchurl {
    url = "https://github.com/mdjurfeldt/guile-mqtt/releases/download/v${finalAttrs.version}/guile-mqtt-${finalAttrs.version}.tar.gz";
    hash = "sha256-6+U3FHewbdI8l7r4pVCrd0DNKPy4BHHy2m/hcQ7ByBQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    guile
    pkg-config
  ];

  buildInputs = [
    guile
    mosquitto
  ];

  meta = {
    description = "Guile bindings for the libmosquitto MQTT client library";
    homepage = "https://gitlab.com/mdjurfeldt/guile-mqtt";
    license = with lib.licenses; [
      lgpl3Plus
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = guile.meta.platforms;
  };
})
