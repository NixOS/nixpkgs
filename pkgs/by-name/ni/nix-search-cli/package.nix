{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "nix-search-cli";
  version = "0.2-unstable-2024-09-24";

  src = fetchFromGitHub {
    owner = "peterldowns";
    repo = "nix-search-cli";
    rev = "7d6b4c501ee448dc2e5c123aa4c6d9db44a6dd12";
    hash = "sha256-0Zms/QVCUKxILLLJYsaodSW64DJrVr/yB13SnNL8+Wg=";
  };

  vendorHash = "sha256-RZuB0aRiMSccPhX30cGKBBEMCSvmC6r53dWaqDYbmyA=";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "CLI for searching packages on search.nixos.org";
    homepage = "https://github.com/peterldowns/nix-search-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.all;
    mainProgram = "nix-search";
  };
}
