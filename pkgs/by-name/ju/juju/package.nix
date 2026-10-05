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
  version = "4.0.12";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NirC6L+Ji4/wb3IWda+487AtDJH/tk2Y4wHYRlK5mJU=";
  };

  vendorHash = "sha256-UtnExwgKBYL7TLEcW9XAlEOfs+UCRrcEtMJ5L1VUBXM=";

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
