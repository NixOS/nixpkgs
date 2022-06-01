{ lib, stdenv, fetchurl, writeText, jq, conf ? {} }:

let
  configOverrides = writeText "cinny-config-overrides.json" (builtins.toJSON conf);
in stdenv.mkDerivation rec {
  pname = "cinny";
  version = "2.0.4";

  src = fetchurl {
    url = "https://github.com/ajbura/cinny/releases/download/v${version}/cinny-v${version}.tar.gz";
    sha256 = "0p5s25nkjs9514a16c7kl0m78vn5f14mv6nbi79yz0sxb7hc12qg";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -R . $out/
    ${jq}/bin/jq -s '.[0] * .[1]' "config.json" "${configOverrides}" > "$out/config.json"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Yet another Matrix client for the web";
    homepage = "https://cinny.in/";
    maintainers = with maintainers; [ abbe ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
