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
  version = "4.0.9";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pHr+9HlDx0CZtSsLW7fIuXPTv/5BhGJqlR/LS6cZGR8=";
  };

  vendorHash = "sha256-kDRK0UVXsVT4zF7IiM1dV3eNVRgyq5WJua1/1rHE4YI=";

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
