{
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  lib,
  installShellFiles,
}:

buildGoModule rec {
  pname = "fly";
  version = "7.12.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    hash = "sha256-lAx9TZVRkPMa5swB74zI0xJ7pbRDApZoens747XcuJk=";
  };

  vendorHash = "sha256-dXjee2rZn1lVEmL8Cy8rrdpSX1OpS9GHKZo53ur3kew=";

  subPackages = [ "fly" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/concourse/concourse.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fly \
      --bash <($out/bin/fly completion --shell bash) \
      --fish <($out/bin/fly completion --shell fish) \
      --zsh <($out/bin/fly completion --shell zsh)
  '';

  meta = with lib; {
    description = "Command line interface to Concourse CI";
    mainProgram = "fly";
    homepage = "https://concourse-ci.org";
    license = licenses.asl20;
    maintainers = with maintainers; [
      ivanbrennan
      SuperSandro2000
    ];
  };
}
