{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "ctlptl";
<<<<<<< HEAD
  version = "0.8.44";
=======
  version = "0.8.43";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = "ctlptl";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-DIVKwfTSA03Yyservf3TK7y9RKi2t6pELyC0cpoUH3I=";
  };

  vendorHash = "sha256-bZd2DWQ2utKYctx9KzE5BzF5wkj1rGkka6PsYb7G8Oo=";
=======
    hash = "sha256-NQLVwa/JLawLM5ImcRlG/XBLZBkS0fhy2gmu5v00w1k=";
  };

  vendorHash = "sha256-ENSW2JGcMjg83/vsmIa4C181WOkZQrRpSVZdfWXl4JY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "CLI for declaratively setting up local Kubernetes clusters";
    homepage = "https://github.com/tilt-dev/ctlptl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ svrana ];
=======
  meta = with lib; {
    description = "CLI for declaratively setting up local Kubernetes clusters";
    homepage = "https://github.com/tilt-dev/ctlptl";
    license = licenses.asl20;
    maintainers = with maintainers; [ svrana ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
