{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_semver";
  version = "0.11.17";

  src = fetchFromGitHub {
    owner = "abusch";
    repo = "nu_plugin_semver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GJ3B7dENuSEZSkHV42plt7tsGLZPqqXCO3c/0ILZQ1Y=";
  };

  cargoHash = "sha256-U3wwXtvnHfbxfH5awVJbSI4OaVd/c/TsQHzaUljw99o=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin to work with semver versions";
    homepage = "https://github.com/abusch/nu_plugin_semver";
    changelog = "https://github.com/abusch/nu_plugin_semver/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ koffydrop ];
    mainProgram = "nu_plugin_semver";
  };
})
