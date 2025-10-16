{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "qc";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "qownnotes";
    repo = "qc";
    rev = "v${version}";
    hash = "sha256-Y7SjlVNiZjWDTRPNZfyoFjI5qyo2SHgTPurNJzGmN0k=";
  };

  vendorHash = "sha256-ad4IuGv2y4L9cS7pf/fEVJ3wXwy9pEIegMTbUoJHPmg=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/qownnotes/qc/cmd.version=${version}"
  ];

  # There are no automated tests
  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export HOME=$(mktemp -d)
    installShellCompletion --cmd qc \
      --bash <($out/bin/qc completion bash) \
      --fish <($out/bin/qc completion fish) \
      --zsh <($out/bin/qc completion zsh)
  '';

  meta = with lib; {
    description = "QOwnNotes command-line snippet manager";
    mainProgram = "qc";
    homepage = "https://github.com/qownnotes/qc";
    license = licenses.mit;
    maintainers = with maintainers; [
      pbek
      totoroot
    ];
  };
}
