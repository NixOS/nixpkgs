{ lib, stdenv, fetchurl, writeText, jq, conf ? {} }:

# Note for maintainers:
# Versions of `element-web` and `element-desktop` should be kept in sync.

let
  noPhoningHome = {
    disable_guests = true; # disable automatic guest account registration at matrix.org
    piwik = false; # disable analytics
  };

  opts = with lib;
    let
      removed = { "features" = [ "feature_irc_ui" "feature_state_counters" "feature_font_scaling" ]; };
    in mapAttrs
      (name: value: let
        attrs = attrNames value;
        handler = if all (o: !(elem o attrs)) (removed.${name} or [])
          then id
          else warn ''
            Please note that the following feature-flags were removed in `element-web` 1.7 (formerly known
            as `riot-web`) and are now available by default:

            - ${concatStringsSep "- " (flatten (mapAttrsToList (
              k: v: map (n: "${k}.${n}\n") v
            ) removed))}

            For further upgrade-instructions please read the changelog:

              https://github.com/vector-im/riot-web/blob/develop/CHANGELOG.md#changes-in-171-2020-07-16
          '';
      in handler value)
      (noPhoningHome // conf);

  configOverrides = writeText "element-config-overrides.json" (builtins.toJSON opts);

in stdenv.mkDerivation rec {
  pname = "element-web";
  version = "1.7.9";

  src = fetchurl {
    url = "https://github.com/vector-im/riot-web/releases/download/v${version}/riot-v${version}.tar.gz";
    sha256 = "00ch486npqgrwmgfd7bsi6wb9ac6dpv08n13lygn45gha37l1kx1";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -R . $out/
    ${jq}/bin/jq -s '.[0] * .[1]' "config.sample.json" "${configOverrides}" > "$out/config.json"

    runHook postInstall
  '';

  meta = {
    description = "A glossy Matrix collaboration client for the web";
    homepage = "https://element.io/";
    maintainers = with stdenv.lib.maintainers; [ pacien worldofpeace ma27 ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
