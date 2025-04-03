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
  version = "3.6.4";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "v${version}";
    hash = "sha256-kXSqOifUkx6ReXBrB19Zx6TbiloaG+G90cIo/+ysIHk=";
  };

  vendorHash = "sha256-xqF5+QvZbC04e2f8/pftfbhXrJjCZKfAcyw74kwgdn4=";

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
