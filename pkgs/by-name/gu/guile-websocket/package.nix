{
  lib,
  stdenv,
  fetchurl,
  guile,
  guile-gnutls,
  texinfo,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-websocket";
  version = "0.3.0";

  src = fetchurl {
    url = "https://files.dthompson.us/releases/guile-websocket/guile-websocket-${finalAttrs.version}.tar.gz";
    hash = "sha256-G6bA0dF19KaLWM4AMldHfjkx/qDXBZOIGqcXfLmUg/w=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    guile
    pkg-config
    texinfo
  ];
  buildInputs = [
    guile
    guile-gnutls
  ];
  doCheck = true;
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  meta = {
    description = "Provides an implementation of the WebSocket protocol in Guile";
    homepage = "https://dthompson.us/projects/guile-websocket.html";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ binarydigitz01 ];
    platforms = lib.platforms.all;
  };
})
