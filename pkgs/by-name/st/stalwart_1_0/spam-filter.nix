{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  stalwart_1_0,
  nix-update-script,
  python3,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "spam-filter";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "spam-filter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-guNyl8SpdCT2gM+kA0vqN/JIUCqD7T1yPtbzUh6n37w=";
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
    inherit (stalwart_1_0.meta) maintainers;
  };
})
