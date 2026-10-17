{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "cargo-unused-workspace-deps";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JarredAllen";
    repo = "cargo-unused-workspace-deps";
    rev = "82ab3f57d6cc2b9d6dd7f0dd9f20f2b03cc9c9c8";
    hash = "sha256-7xj4Xh2imvTRXzl6obVjziQqrgJfXZXhdV7hDbeYDTE=";
  };

  cargoHash = "sha256-KzfOztkLpP658G0J/AFLDh8qsdUNAOQpT4fReQ2fahU=";

  meta = {
    description = "Cargo tool that detects unused dependencies in workspace manifests";
    mainProgram = "cargo-unused-workspace-deps";
    homepage = "https://github.com/JarredAllen/cargo-unused-workspace-deps";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      arizzo35
    ];
  };
}
