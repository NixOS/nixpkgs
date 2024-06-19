{ lib, fetchFromGitHub, buildGoModule, installShellFiles, testers, juju }:

buildGoModule rec {
  pname = "juju";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "v${version}";
    hash = "sha256-VOGkAv42dus2uxoffffIn6dwC18idwF2tycEHLd6I4s=";
  };

  vendorHash = "sha256-2JNEN8fmxflEyP5lHAv75Bjt9sbKoWL5O+87hxK89vU=";

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
