{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  openbao,
}:
buildGoModule rec {
  pname = "openbao";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao";
    rev = "v${version}";
    hash = "sha256-QzUNb4T9uau9bWZX6ulUDyfdInGd86iClBAG72C+7mo=";
  };

  vendorHash = "sha256-Lg58NbwO7vLNRCBwJujcoVcrV018FevvdrUassnAg3k=";

  proxyVendor = true;

  subPackages = [ "." ];

  tags = [
    "openbao"
    "bao"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/openbao/openbao/version.GitCommit=${src.rev}"
    "-X github.com/openbao/openbao/version.fullVersion=${version}"
  ];

  postInstall = ''
    mv $out/bin/openbao $out/bin/bao
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
    maintainers = with maintainers; [ brianmay ];
  };
}
