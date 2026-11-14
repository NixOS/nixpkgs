{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  testers,
  juju,
}:

buildGoModule (finalAttrs: {
  pname = "juju";
  version = "4.0.16";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JS/hLd6s5L8H78aj+ROZtjHuPysxO8kd/QmrrEPxsls=";
  };

  vendorHash = "sha256-PVatDTls9w4K3+ilSGO0JK4Cr6/1497GdJ3nYlIEZvE=";

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

  meta = {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ citadelcore ];
    mainProgram = "juju";
  };
})
