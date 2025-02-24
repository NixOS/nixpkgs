{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "docker-color-output";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "devemio";
    repo = pname;
    rev = "${version}";
    hash = "sha256-rnCZ+6t6iOiLBynp1EPshO+/otAdtu8yy1FqFkYB07w=";
  };

  vendorHash = null;

  meta = {
    description = "Add color to the Docker CLI";
    mainProgram = "docker-color-output";
    license = lib.licenses.mit;
    homepage = "https://github.com/devemio/docker-color-output";
    maintainers = with lib.maintainers; [ sguimmara ];
  };
}
