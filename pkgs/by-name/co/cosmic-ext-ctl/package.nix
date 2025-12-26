{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  cosmic-comp,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-ext-ctl";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-URqNhkC1XrXYxr14K6sT3TLso38eWLMA+WplBdj52Vg=";
  };

  cargoHash = "sha256-OL1LqOAyIFFCGIp3ySdvEXJ1ECp9DgC/8mfAPo/E7k4=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/cosmic-ctl";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for COSMIC Desktop configuration management";
    changelog = "https://github.com/cosmic-utils/cosmic-ctl/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/cosmic-utils/cosmic-ctl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    mainProgram = "cosmic-ctl";
    inherit (cosmic-comp.meta) platforms;
  };
})
