{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "qc";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "qownnotes";
    repo = "qc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UaJ6ujKY9os5N8RhyUbj/speRrrJRIbemRQeFtkiijg=";
  };

  vendorHash = "sha256-/nRPv6SlvWV8mHlQstV19BLou9iwGt/VvJbrpVwiTCU=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/qownnotes/qc/cmd.version=${finalAttrs.version}"
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

  meta = {
    description = "QOwnNotes command-line snippet manager";
    mainProgram = "qc";
    homepage = "https://github.com/qownnotes/qc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pbek
      totoroot
    ];
  };
})
