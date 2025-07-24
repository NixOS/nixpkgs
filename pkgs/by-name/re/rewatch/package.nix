{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rewatch";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rewatch";
    tag = "v${version}";
    hash = "sha256-HqgAGqT6D9M32PXWB0OlpxBhGu3xeE/GS/qdZ4qS+xU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mhC64l1+gBS7FCkg3s1p1DFf4db177mCzaWCNBCCPYw=";

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Alternative build system for the Rescript Compiler";
    homepage = "https://github.com/rescript-lang/rewatch";
    changelog = "https://github.com/rescript-lang/rewatch/releases/tag/v${version}";
    mainProgram = "rewatch";
    maintainers = with lib.maintainers; [ r17x ];
    license = lib.licenses.mit;
  };
}
