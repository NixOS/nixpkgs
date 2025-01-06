{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  testers,
  juju,
}:

buildGoModule rec {
  pname = "juju";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "v${version}";
    hash = "sha256-eq7C3F/OJWF/HWMO9I+yTlXeskO1xuTKGhmoNNGQcyM=";
  };

  vendorHash = "sha256-+2MeUq+r0/2I8C/8IVZTxrKIZTS36P/9XHM2X41AZPE=";

  subPackages = [
    "cmd/juju"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  postInstall = ''
    for file in etc/bash_completion.d/*; do
      installShellCompletion --bash "$file"
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = juju;
    command = "HOME=\"$(mktemp -d)\" juju --version";
  };

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
    mainProgram = "juju";
  };
}
