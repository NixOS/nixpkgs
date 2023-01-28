{ stdenv
, jq
, element-web-unwrapped
, conf ? { }
}:

if (conf == { }) then element-web-unwrapped else
stdenv.mkDerivation rec {
  pname = "${element-web-unwrapped.pname}-wrapped";
  inherit (element-web-unwrapped) version meta;

  dontUnpack = true;

  nativeBuildInputs = [ jq ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    ln -s ${element-web-unwrapped}/* $out
    rm $out/config.json
    jq -s '.[0] * $conf' "${element-web-unwrapped}/config.json" --argjson "conf" '${builtins.toJSON conf}' > "$out/config.json"

    runHook postInstall
  '';
}
