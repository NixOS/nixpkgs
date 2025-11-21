{
  cinny-unwrapped,
  jq,
  stdenvNoCC,
  writeText,
  conf ? { },
}:
let
  configOverrides = writeText "cinny-config-overrides.json" (builtins.toJSON conf);
in
if (conf == { }) then
  cinny-unwrapped
else
  stdenvNoCC.mkDerivation {
    pname = "cinny";
    inherit (cinny-unwrapped) version meta;

    dontUnpack = true;

    nativeBuildInputs = [ jq ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      ln -s ${cinny-unwrapped}/* $out
      rm $out/config.json
      jq -s '.[0] * .[1]' "${cinny-unwrapped}/config.json" "${configOverrides}" > "$out/config.json"

      runHook postInstall
    '';
  }
