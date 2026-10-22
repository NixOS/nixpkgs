{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "git-lfs-transfer";
  version = "0.1.0-unstable-2026-08-12";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "git-lfs-transfer";
    rev = "971c0284dc33b1ed3f7ed9dde5d4fc0cee62db6b";
    hash = "sha256-RBkz9JdxQ93pfge/9gWniin3PRuajHnOK864v1wedBM=";
  };

  vendorHash = "sha256-JoRI7kQWZZ3gJDm1eVYKhe0SKoBMcx5lGymeYAc243g=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v([0-9.]*(?:-unstable-[0-9-]*))"
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Server-side implementation of the Git LFS pure-SSH protocol";
    mainProgram = "git-lfs-transfer";
    homepage = "https://github.com/charmbracelet/git-lfs-transfer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chn ];
  };
}
