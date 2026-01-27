{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "git-appraise";
  version = "unstable-2022-04-13";

  src = fetchFromGitHub {
    owner = "google";
    repo = "git-appraise";
    rev = "99aeb0e71544d3e1952e208c339b1aec70968cf3";
    hash = "sha256-TteTI8yGP2sckoJ5xuBB5S8xzm1upXmZPlcDLvXZrpc=";
  };

  vendorHash = "sha256-Lzq4qpDAUjKFA2T685eW9NCfzEhDsn5UR1A1cIaZadE=";

  ldflags = [
    "-s"
    "-w"
  ];

  # git-appraise doesn't support --version
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Distributed code review system for Git repos";
    homepage = "https://github.com/google/git-appraise";
    changelog = "https://github.com/google/git-appraise/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vdemeester ];
    mainProgram = "git-appraise";
  };
})
