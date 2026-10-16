{
  lib,
  buildGoModule,
  fetchFromGitHub,
  docker,
}:

buildGoModule (finalAttrs: {
  pname = "fn";
  version = "0.6.70";

  src = fetchFromGitHub {
    owner = "fnproject";
    repo = "cli";
    rev = finalAttrs.version;
    hash = "sha256-ClN5k1+Ja4ptY95atEe4ihFkarhw4rItllbpsT0QIkI=";
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
