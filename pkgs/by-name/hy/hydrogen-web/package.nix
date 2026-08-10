{
  stdenv,
  jq,
  hydrogen-web-unwrapped,
  config,
  conf ? config.hydrogen-web.conf or { },
}:

if conf == { } then
  hydrogen-web-unwrapped
else
  stdenv.mkDerivation (finalAttrs: {
    pname = "${hydrogen-web-unwrapped.pname}-wrapped";
    inherit (hydrogen-web-unwrapped) version meta;

    strictDeps = true;
    __structuredAttrs = true;

    dontUnpack = true;

    nativeBuildInputs = [ jq ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      ln -s ${hydrogen-web-unwrapped}/* $out
      rm $out/config.json
      jq -s '.[0] * $conf' "${hydrogen-web-unwrapped}/config.json" --argjson "conf" '${builtins.toJSON conf}' > "$out/config.json"

      runHook postInstall
    '';
  })
