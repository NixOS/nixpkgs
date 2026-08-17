{
  lib,
  fetchFromGitHub,
  stdenv,
  stalwart_0_16,
  nix-update-script,
  python3Packages,
}:
let
  generate_rules_json =
    {
      src,
      version,
    }:
    python3Packages.buildPythonApplication {
      pname = "generate_rules_json";
      inherit src version;
      __structuredAttrs = true;
      format = "other";
      dontBuild = true;
      dependencies = [ python3Packages.tomli ];
      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        cp generate_rules_json.py $out/bin/generate_rules_json
        chmod +x $out/bin/generate_rules_json
        runHook postInstall
      '';
      postFixup = ''
        wrapPythonPrograms
      '';
      patches = [ ./spam-filter-generate-rules-json-use-current-working-dir.patch ];
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "spam-filter";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "spam-filter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mADA62eOHV7cJf4khkLh/OX0eQHRUus6nlGkieGFsKA=";
  };

  __structuredAttrs = true;

  buildPhase = ''
    runHook preBuild
    ${generate_rules_json { inherit (finalAttrs) src version; }}/bin/generate_rules_json
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp spam-filter.toml $out/
    cp spam-filter-rules.json.gz $out/
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Spam filter module for the Stalwart server";
    homepage = "https://github.com/stalwartlabs/spam-filter";
    changelog = "https://github.com/stalwartlabs/spam-filter/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    inherit (stalwart_0_16.meta) maintainers;
  };
})
