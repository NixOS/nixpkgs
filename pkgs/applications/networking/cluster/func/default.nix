{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, func }:

buildGoModule rec {
  pname = "func";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "knative";
    repo = "func";
    rev = "knative-v${version}";
    sha256 = "sha256-LrWRY22deh+YL/cLb+ZwK93okVPgysBoMCmo2MrbqIs=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/func" ];

  ldflags = [
    "-X main.vers=v${version}"
    "-X main.date=19700101T000000Z"
    "-X main.hash=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];


  postInstall = ''
    installShellCompletion --cmd func \
      --bash <($out/bin/func completion bash) \
      --zsh <($out/bin/func completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = func;
    command = "func version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "The Knative client library and CLI for creating, building, and deploying Knative Functions";
    homepage = "https://github.com/knative/func";
    changelog = "https://github.com/knative/func/releases/tag/knative-v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ maxwell-lt ];
  };
}
