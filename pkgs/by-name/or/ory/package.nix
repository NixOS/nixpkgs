{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "ory";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-q7+Fpttgx62GbKxCCiEDlX//e/pNO24e7KhhBeGRDH0=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "." ];

  env.CGO_ENABLED = 1;

  tags = [
    "sqlite"
  ];

  vendorHash = "sha256-B0y1JVjJmC5eitn7yIcDpl+9+xaBDJBMdvm+7N/ZxTk=";

  postInstall = ''
    mv $out/bin/cli $out/bin/ory
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ory \
      --bash <($out/bin/ory completion bash) \
      --fish <($out/bin/ory completion fish) \
      --zsh <($out/bin/ory completion zsh)
  '';

  meta = with lib; {
    description = "CLI for Ory";
    mainProgram = "ory";
    homepage = "https://www.ory.sh/cli";
    license = licenses.asl20;
    maintainers = with maintainers; [
      luleyleo
      nicolas-goudry
    ];
  };
}
