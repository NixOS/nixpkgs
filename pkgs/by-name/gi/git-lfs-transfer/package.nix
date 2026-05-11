{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "git-lfs-transfer";
  version = "0.1.0-unstable-2024-10-07";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "git-lfs-transfer";
    rev = "422d24414fe4b803849b3f6fe7c4d8ab1b40803b";
    hash = "sha256-YsplPW3i4W1RfkWQI1eGXFXb3JofQwKe+9LbjxeL1cM=";
  };

  vendorHash = "sha256-1cGlhLdnU6yTqzcB3J1cq3gawncbtdgkb3LFh2ZmXbM=";

  meta = {
    description = "Server-side implementation of the Git LFS pure-SSH protocol";
    mainProgram = "git-lfs-transfer";
    homepage = "https://github.com/charmbracelet/git-lfs-transfer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chn ];
  };
}
