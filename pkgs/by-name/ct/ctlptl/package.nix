{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "ctlptl";
  version = "0.8.44";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = "ctlptl";
    rev = "v${version}";
    hash = "sha256-DIVKwfTSA03Yyservf3TK7y9RKi2t6pELyC0cpoUH3I=";
  };

  vendorHash = "sha256-bZd2DWQ2utKYctx9KzE5BzF5wkj1rGkka6PsYb7G8Oo=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/ctlptl" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ctlptl \
      --bash <($out/bin/ctlptl completion bash) \
      --fish <($out/bin/ctlptl completion fish) \
      --zsh <($out/bin/ctlptl completion zsh)
  '';

  meta = {
    description = "CLI for declaratively setting up local Kubernetes clusters";
    homepage = "https://github.com/tilt-dev/ctlptl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ svrana ];
  };
}
