{ lib, stdenv, fetchurl, writeText, conf ? null }:

# Note for maintainers:
# Versions of `riot-web` and `riot-desktop` should be kept in sync.

stdenv.mkDerivation rec {
  pname = "riot-web";
  version = "1.5.8";

  src = fetchurl {
    url = "https://github.com/vector-im/riot-web/releases/download/v${version}/riot-v${version}.tar.gz";
    sha256 = "112zjlmxy2s8qcd227laf1lfvbbwwcipn51xb779hy2dci48kpkx";
  };

  installPhase = let
    configFile = if (conf != null)
      then writeText "riot-config.json" conf
      else "$out/config.sample.json";
  in ''
    runHook preInstall

    mkdir -p $out/
    cp -R . $out/
    ln -s ${configFile} $out/config.json

    runHook postInstall
  '';

  meta = {
    description = "A glossy Matrix collaboration client for the web";
    homepage = http://riot.im/;
    maintainers = with stdenv.lib.maintainers; [ bachp pacien ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
