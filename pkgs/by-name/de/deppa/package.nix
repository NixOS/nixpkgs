{
  buildGoModule,
  fetchFromGitea,
  installShellFiles,
  lib,
  ...
}:
buildGoModule {
  pname = "deppa";
  version = "1.2";

  src = fetchFromGitea {
    domain = "git.linfan.moe";
    owner = "chiyokolinux";
    repo = "deppa";
    rev = "56827d62a6c5734b4aa16d4d4871a8ccc6172b54";
    hash = "sha256-inpFeQR2cZTIZidGPn2sZptvWnZAIrT3/Z1jZZAgMHE=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  prePatch = ''
    cat <<EOF > go.mod
    module linfan.moe/deppa
    go 1.24.0
    EOF
  '';

  postInstall = ''
    installManPage deppa.8
  '';

  vendorHash = null;

  meta = {
    description = "Server implementation of the internet gopher protocol";
    homepage = "https://git.linfan.moe/chiyokolinux/deppa";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ void ];
  };
}
