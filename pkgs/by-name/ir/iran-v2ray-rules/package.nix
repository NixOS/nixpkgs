{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  pname = "v2ray-iran-geo";
  version = "202611251453";

  geosite = fetchurl {
    url = "https://github.com/Chocolate4U/Iran-v2ray-rules/releases/download/${version}/geosite.dat";
    hash = "sha256-e4AlA46s/omzv4tL7gwn1XaebHjidiec8Jy4EY5QOi4=";
  };

  geoip = fetchurl {
    url = "https://github.com/Chocolate4U/Iran-v2ray-rules/releases/download/${version}/geoip.dat";
    hash = "sha256-/rCoVkXMlU/CzlUXJfcpnek4YFqRH9btkBaYPTsydLM=";
  };

in
stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    geosite
    geoip
    ;

  __structuredAttrs = true;

  strictDeps = true;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 "$geosite" "$out/share/v2ray/geosite.dat"
    install -Dm644 "$geoip" "$out/share/v2ray/geoip.dat"
    runHook postInstall
  '';

  meta = {
    description = "Iran-specific GeoIP and GeoSite rules for V2Ray";
    longDescription = ''
      Iran-specific GeoIP and GeoSite databases maintained by
      [Chocolate4U](https://github.com/Chocolate4U/Iran-v2ray-rules).

      See the [upstream README](https://github.com/Chocolate4U/Iran-v2ray-rules#readme)
      for installation instructions and recommended routing rules.
    '';
    homepage = "https://github.com/Chocolate4U/Iran-v2ray-rules";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pouya ];
  };
}
