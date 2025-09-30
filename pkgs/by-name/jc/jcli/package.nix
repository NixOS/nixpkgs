{
  lib,
  stdenv,
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "jcli";
  version = "0.0.47";

  src = fetchFromGitHub {
    owner = "jenkins-zh";
    repo = "jenkins-cli";
    tag = "v${version}";
    hash = "sha256-HsuYTgGe0cDRAG5FP77CGJG+xCDSWjBthPeAclmqd44=";
  };

  vendorHash = "sha256-Ld59i91k1tyR9BhlRohHiRPB8Zt3rQWMtRw+J+13TFw=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/linuxsuren/cobra-extension/version.version=${version}"
  ];

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      jcliBin =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out"
        else
          lib.getBin buildPackages.jcli;
    in
    ''
      mv $out/bin/{jenkins-cli,jcli}

      installShellCompletion --cmd jcli \
        --bash <(${jcliBin}/bin/jcli completion --type bash) \
        --fish <(${jcliBin}/bin/jcli completion --type fish) \
        --zsh <(${jcliBin}/bin/jcli completion --type zsh)
    '';

  meta = {
    description = "Jenkins CLI allows you to manage your Jenkins in an easy way";
    mainProgram = "jcli";
    homepage = "https://github.com/jenkins-zh/jenkins-cli";
    changelog = "https://github.com/jenkins-zh/jenkins-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
