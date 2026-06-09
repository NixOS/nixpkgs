{
  lib,
  buildGoModule,
  fetchFromGitHub,
  docker,
}:

buildGoModule (finalAttrs: {
  pname = "fn";
  version = "0.6.60";

  src = fetchFromGitHub {
    owner = "fnproject";
    repo = "cli";
    rev = finalAttrs.version;
    hash = "sha256-DsDUVumixQh5R3wVYGU5cfcIICnbLWMQMbZRz3xSnk0=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  buildInputs = [
    docker
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    mv $out/bin/cli $out/bin/fn
  '';

  meta = {
    description = "Command-line tool for the fn project";
    mainProgram = "fn";
    homepage = "https://fnproject.io";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.c4605 ];
  };
})
