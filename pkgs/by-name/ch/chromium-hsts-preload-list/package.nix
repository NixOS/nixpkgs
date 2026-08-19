{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chromium-hsts-preload-list";
  version = "153.0.7990.1";

  src = fetchurl {
    url = "https://raw.github.com/chromium/chromium/${finalAttrs.version}/net/http/transport_security_state_static.json";
    hash = "sha256-ObT9lWtjw/V0UGY552pEWJ6KbfF0izB/zJ7v+00IFB8=";
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
