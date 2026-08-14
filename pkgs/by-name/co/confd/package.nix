{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "confd";
  version = "0.16-unstable-2023-12-09";

  src = fetchFromGitHub {
    owner = "kelseyhightower";
    repo = "confd";
    rev = "919444eb6cf721d198b2bb18581d0f0b3734d107";
    hash = "sha256-/HlL+vxERSOUKIxdtlZDZrpYjGXon3KMwoYUcp8iOug=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Manage local application configuration files using templates and data from etcd or consul";
    homepage = "https://github.com/kelseyhightower/confd";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zimbatm ];
    mainProgram = "confd";
  };
}
