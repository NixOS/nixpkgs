{ lib, stdenv, fetchurl, writeText, jq, conf ? {} }:

# Note for maintainers:
# Versions of `riot-web` and `riot-desktop` should be kept in sync.

let
  privacyOverrides = writeText "riot-config-privacy.json" (builtins.toJSON {
    disable_guests = true; # disable automatic guest account registration at matrix.org
    piwik = false; # disable analytics
  });
  userOverrides = writeText "riot-config-user.json" (
    with builtins; if isAttrs conf then toJSON conf else conf
  );

in stdenv.mkDerivation rec {
  pname = "riot-web";
  version = "1.5.13";

  src = fetchurl {
    url = "https://github.com/vector-im/riot-web/releases/download/v${version}/riot-v${version}.tar.gz";
    sha256 = "0xghpf9rv7ns5aipc6n517qd9dp50rr93arvx6r36kqhkdyzbfad";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -R . $out/

    ${jq}/bin/jq -s '.[0] * .[1] * .[2]' \
      "config.sample.json" \
      "${privacyOverrides}" \
      "${userOverrides}" \
      > "$out/config.json"

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
