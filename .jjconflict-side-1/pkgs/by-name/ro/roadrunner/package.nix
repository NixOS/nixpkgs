{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "roadrunner";
  version = "2024.2.1";

  src = fetchFromGitHub {
    repo = "roadrunner";
    owner = "roadrunner-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-uZUC2+sdMka6Q++Xm5y0KZnOifW/WcFi+XqnuepdErI=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  # Flags as provided by the build automation of the project:
  # https://github.com/roadrunner-server/roadrunner/blob/fe572d0eceae8fd05225fbd99ba50a9eb10c4393/.github/workflows/release.yml#L89
  ldflags = [
    "-s"
    "-X=github.com/roadrunner-server/roadrunner/v2023/internal/meta.version=${version}"
    "-X=github.com/roadrunner-server/roadrunner/v2023/internal/meta.buildTime=1970-01-01T00:00:00Z"
  ];

  postInstall = ''
    installShellCompletion --cmd rr \
      --bash <($out/bin/rr completion bash) \
      --zsh <($out/bin/rr completion zsh) \
      --fish <($out/bin/rr completion fish)
  '';

  postPatch = ''
    substituteInPlace internal/rpc/client_test.go \
      --replace "127.0.0.1:55555" "127.0.0.1:55554"

    substituteInPlace internal/rpc/test/config_rpc_ok.yaml \
      --replace "127.0.0.1:55555" "127.0.0.1:55554"

    substituteInPlace internal/rpc/test/config_rpc_conn_err.yaml \
      --replace "127.0.0.1:0" "127.0.0.1:55554"
  '';

  vendorHash = "sha256-JHJkL99Liz9qvh3oEDYBSMueh+OItXyuxk4uHYC31po=";

  meta = {
    changelog = "https://github.com/roadrunner-server/roadrunner/blob/v${version}/CHANGELOG.md";
    description = "High-performance PHP application server, process manager written in Go and powered with plugins";
    homepage = "https://roadrunner.dev";
    license = lib.licenses.mit;
    mainProgram = "rr";
    maintainers = with lib.maintainers; [ shyim ];
  };
}
