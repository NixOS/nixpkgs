{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rewatch";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rewatch";
    tag = "v${version}";
    hash = "sha256-9MowIppTEU2+g5T76qoZg2dOFyEo6uUmtZtzvuaqCrg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-129RFd0kbhiaQOxUlnZMVK2bFXe08VBy3keYNlASRtg=";

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
