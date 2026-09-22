{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "harmonia";
  version = "3.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "harmonia";
    tag = "harmonia-v${finalAttrs.version}";
    hash = "sha256-Q25ZdQ47e3SR/pUf/l9TrmEXvdW9eGSd9Vk3njnXbms=";
  };

  cargoHash = "sha256-dfQDf+sJYZ0sgcGiQ9BxNQIKEFCNyvYqEmWRUq/SA10=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "harmonia-v(.*)"
      ];
    };
    tests = { inherit (nixosTests) harmonia harmonia-gc; };
  };

  meta = {
    description = "Nix binary cache";
    homepage = "https://github.com/nix-community/harmonia";
    changelog = "https://github.com/nix-community/harmonia/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
    mainProgram = "harmonia-cache";
  };
})
