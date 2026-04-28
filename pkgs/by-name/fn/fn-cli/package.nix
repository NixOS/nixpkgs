{
  lib,
  buildGoModule,
  fetchFromGitHub,
  docker,
}:

buildGoModule (finalAttrs: {
  pname = "fn";
  version = "0.6.49";

  src = fetchFromGitHub {
    owner = "fnproject";
    repo = "cli";
    rev = finalAttrs.version;
    hash = "sha256-qDLBwxMDVPY2WWCAGw7jFwHX9qAnqOuz9Tgfg1EC1bc=";
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
