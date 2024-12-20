{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "jcli";
  version = "0.0.43";

  src = fetchFromGitHub {
    owner = "jenkins-zh";
    repo = "jenkins-cli";
    rev = "v${version}";
    hash = "sha256-IUYkpeWZOuCF0cR664VbwvLuDBQqbTKxn9UUe6G9VEE=";
  };

  vendorHash = "sha256-f2f/Qi6aav7LPpO9ERYkejygz0XiPQ8YrKLB63EpaoY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/linuxsuren/cobra-extension/version.version=${version}"
  ];

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    ''
      mv $out/bin/{jenkins-cli,jcli}
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd jcli \
        --bash <($out/bin/jcli completion --type bash) \
        --zsh <($out/bin/jcli completion --type zsh)
    '';

  meta = {
    description = "Jenkins CLI allows you to manage your Jenkins in an easy way";
    mainProgram = "jcli";
    homepage = "https://github.com/jenkins-zh/jenkins-cli";
    changelog = "https://github.com/jenkins-zh/jenkins-cli/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
