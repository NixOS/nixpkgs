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
  version = "0.2.1";

  # building from git repo requires nyacc>=2.01.3
  src = fetchurl {
    url = "https://github.com/mdjurfeldt/guile-mqtt/releases/download/v${finalAttrs.version}/guile-mqtt-${finalAttrs.version}.tar.gz";
    hash = "sha256-+qfrUw8yIY8iObEVLbg6bOfiQNR5Lkw2n9oHMr3JQ5k=";
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
