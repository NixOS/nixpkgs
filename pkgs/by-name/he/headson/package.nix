{
  lib,
  rustPlatform,
  stdenvNoCC,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "headson";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "kantord";
    repo = "headson";
    tag = "v${finalAttrs.version}";
    hash =
      if stdenvNoCC.isDarwin then
        "sha256-Fnba2XlEZo+KTmVSvqrg2OswCOrw7y+LP/4WXxxRiFg="
      else
        "sha256-XruOpiurs1SJeVlZObUSSygOt+jX2bqPXhEQFblVVfQ=";
  };

  cargoHash = "sha256-wlXBNFl2OImcvdSPjjcFSzLomeoTwPBIrLdTJXfX+Hg=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "`head`/`tail` for structured data";
    longDescription = ''
      Structure‑aware `head`/tail` for JSON and YAML.  Get a compact
      preview that shows both the shape and representative values of
      your data, all within a strict byte budget.  (Just like
      `head`/`tail`, `headson` can also work with unstructured text
      files.)
    '';
    homepage = "https://github.com/kantord/headson";
    changelog = "https://github.com/kantord/headson/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "headson";
  };
})
