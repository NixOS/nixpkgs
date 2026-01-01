{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "hostctl";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "guumaster";
    repo = "hostctl";
    rev = "v${version}";
    hash = "sha256-9BbPHqAZKw8Rpjpdd/e9ip3V0Eh06tEFt/skQ97ij4g=";
  };

  vendorHash = "sha256-+p1gIqklTyd/AU1q0zbQN4BwxOM910fBFmkqvbFAbZA=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/guumaster/hostctl/cmd/hostctl/actions.version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hostctl \
      --bash <($out/bin/hostctl completion bash) \
      --zsh <($out/bin/hostctl completion zsh)
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "CLI tool to manage the /etc/hosts file";
    longDescription = ''
      This tool gives you more control over the use of your hosts file.
      You can have multiple profiles and switch them on/off as you need.
    '';
    homepage = "https://guumaster.github.io/hostctl/";
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "hostctl";
  };
}
