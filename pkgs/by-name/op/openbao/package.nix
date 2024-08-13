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
  testers,
  openbao,
}:

buildGoModule rec {
  pname = "openbao";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao";
    rev = "v${version}";
    hash = "sha256-2dylOra/XuAQMIeb05Lp2nqLxXhPmSK+4poSaZ0GzJs=";
  };

  vendorHash = "sha256-vdjoYw0VWNdMYJERFj2RAO63WbDShgeyNili5BFEPUk=";

  proxyVendor = true;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  tags = [
    "openbao"
    "bao"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/openbao/openbao/version.GitCommit=${src.rev}"
  ];

  postInstall =
    ''
      mv $out/bin/openbao $out/bin/bao
      echo "complete -C $out/bin/bao bao" > bao.bash
      installShellCompletion bao.bash
    ''
    + lib.optionalString stdenv.isLinux ''
      wrapProgram $out/bin/bao \
        --prefix PATH ${
          lib.makeBinPath [
            gawk
            glibc
          ]
        }
    '';

  # TODO: Enable the NixOS tests after adding OpenBao as a NixOS service in an upcoming PR and
  # adding NixOS tests
  #
  # passthru.tests = { inherit (nixosTests) vault vault-postgresql vault-dev vault-agent; };

  passthru.tests.version = testers.testVersion {
    package = openbao;
    command = "HOME=$(mktemp -d) bao --version";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://www.openbao.org/";
    description = "Open source, community-driven fork of Vault managed by the Linux Foundation";
    changelog = "https://github.com/openbao/openbao/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    mainProgram = "bao";
    maintainers = with maintainers; [ joseph-flinn ];
  };
}
