{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chromium-hsts-preload-list";
  version = "151.0.7891.2";

  src = fetchurl {
    url = "https://raw.github.com/chromium/chromium/${finalAttrs.version}/net/http/transport_security_state_static.json";
    hash = "sha256-YuiotSk0Lf3IHz/UjgCmU/brdB1lszob6DN4DXyjiWU=";
  };

  dontUnpack = true;
  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 $src $out/share/chromium-hsts-preload-list/transport_security_state_static.json

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Chromium HSTS preload list";
    homepage = "https://www.chromium.org/hsts/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ schembriaiden ];
    platforms = lib.platforms.all;
  };
})
