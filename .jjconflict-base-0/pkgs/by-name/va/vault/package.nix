{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  nixosTests,
  makeWrapper,
  gawk,
  glibc,
}:

buildGoModule rec {
  pname = "vault";
  version = "1.18.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    hash = "sha256-Y5F1qE1zwiX+2mAYxBpoybIHlFaY62WMg88jrjCVqSc=";
  };

  vendorHash = "sha256-SSjoaHp6xpz01vtF7mKLNbX/yDS3RXetZzibwI0OCVI=";

  proxyVendor = true;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  tags = [ "vault" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/vault/sdk/version.GitCommit=${src.rev}"
    "-X github.com/hashicorp/vault/sdk/version.Version=${version}"
    "-X github.com/hashicorp/vault/sdk/version.VersionPrerelease="
  ];

  postInstall =
    ''
      echo "complete -C $out/bin/vault vault" > vault.bash
      installShellCompletion vault.bash
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/vault \
        --prefix PATH ${
          lib.makeBinPath [
            gawk
            glibc
          ]
        }
    '';

  passthru.tests = {
    inherit (nixosTests)
      vault
      vault-postgresql
      vault-dev
      vault-agent
      ;
  };

  meta = with lib; {
    homepage = "https://www.vaultproject.io/";
    description = "Tool for managing secrets";
    changelog = "https://github.com/hashicorp/vault/blob/v${version}/CHANGELOG.md";
    license = licenses.bsl11;
    mainProgram = "vault";
    maintainers = with maintainers; [
      rushmorem
      lnl7
      offline
      pradeepchhetri
      Chili-Man
      techknowlogick
    ];
  };
}
