{ lib, fetchFromGitHub, buildGoModule, installShellFiles, testers, juju }:

buildGoModule rec {
  pname = "juju";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "v${version}";
    hash = "sha256-sp4KLRKII1oEmdbCHzs5fbE/68NbKrHE3bxO14byYFk=";
  };

  vendorHash = "sha256-a50W9V1xxmItHS2DZkkXYEZ7I6aJxDo1+IriOlMPDyw=";

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
