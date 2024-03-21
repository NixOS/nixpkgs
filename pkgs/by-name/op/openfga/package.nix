{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, openfga
}:

buildGoModule rec {
  pname = "openfga";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "openfga";
    rev = "v${version}";
    hash = "sha256-R/KW3TeVhQtlg16ShCsQhXXnzlFA2PoLbFIRQWWmkFM=";
  };

  vendorHash = "sha256-9stk91Ga5hTKXvLxBmmBf5ShtEEXxO+ZEAt8Nb5YPcA=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/openfga/openfga/internal/build.Version=v${version}"
    "-X=github.com/openfga/openfga/internal/build.Commit=${src.rev}"
    "-X=github.com/openfga/openfga/internal/build.Date="
    "-X=github.com/openfga/openfga/internal/build.ProjectName=${pname}"
  ];


  subPackages = [ "cmd/openfga" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd openfga \
      --bash <($out/bin/openfga completion bash) \
      --fish <($out/bin/openfga completion fish) \
      --zsh <($out/bin/openfga completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = openfga;
      version = src.rev;
      command = "openfga version";
    };
  };

  meta = with lib; {
    description = "A high performance and flexible authorization/permission engine built for developers and inspired by Google Zanzibar";
    homepage = "https://github.com/openfga/openfga";
    changelog = "https://github.com/openfga/openfga/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "openfga";
  };
}
