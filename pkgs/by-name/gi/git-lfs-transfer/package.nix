{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "git-lfs-transfer";
  version = "0.1.0-unstable-2025-05-05";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "git-lfs-transfer";
    rev = "0d51139d5979491e819ba4751235e2ab4b763c6e";
    hash = "sha256-cufY0CdkTIVHFH3LesAxMDV4KNIqjxFO2m3dLoBNM9U=";
  };

  vendorHash = "sha256-Uz99CTBr6nOdtducBTRvYcPbtvzMiIWh895uRkRyIGI=";

  meta = {
    description = "Server-side implementation of the Git LFS pure-SSH protocol";
    mainProgram = "git-lfs-transfer";
    homepage = "https://github.com/charmbracelet/git-lfs-transfer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chn ];
  };
}
