{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  stalwart_0_16,
  nix-update-script,
  python3,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "spam-filter";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "spam-filter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mADA62eOHV7cJf4khkLh/OX0eQHRUus6nlGkieGFsKA=";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [ python3 ];

  buildPhase = ''
    runHook preBuild
    python3 generate_rules_json.py
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp spam-filter-rules.json.gz $out
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
