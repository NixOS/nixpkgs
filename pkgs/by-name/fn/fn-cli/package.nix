{
  lib,
  buildGoModule,
  fetchFromGitHub,
  docker,
}:

buildGoModule (finalAttrs: {
  pname = "fn";
  version = "0.6.61";

  src = fetchFromGitHub {
    owner = "fnproject";
    repo = "cli";
    rev = finalAttrs.version;
    hash = "sha256-uw4fH3PyuAnNEhrvw0dl2jJxP4jau3tVuAjzSgeu1Lw=";
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
