{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-qzNH8qGpSNtGQqce3E/mEQoJUP2mQsQ8ntTi9F3ol1I=";
  };

  buildAndTestSubdir = "harper-ls";
  useFetchCargoVendor = true;
  cargoHash = "sha256-PxYRQ6nYHXXgxb8YXkm57wIFXQrF5+cdEHA+CMk22wg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pbsds
      sumnerevans
    ];
    mainProgram = "harper-ls";
  };
}
