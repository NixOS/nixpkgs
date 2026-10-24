{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "protoc-gen-buffa";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "buffa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D0PWwALMdZ9NeAdfvOmiygrRQRGUrb45JzbndPPLgW0=";
  };

  cargoHash = "sha256-V7Oh4z4MLPazA/KZlsxMEsOZbewyPsvbwJ6QVgsoz/0=";

  cargoBuildFlags = [
    "-p"
    "protoc-gen-buffa"
  ];

  cargoTestFlags = [
    "-p"
    "protoc-gen-buffa"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Protoc plugin for generating Rust code with buffa";
    homepage = "https://github.com/anthropics/buffa";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ macalinao ];
    mainProgram = "protoc-gen-buffa";
  };
})
