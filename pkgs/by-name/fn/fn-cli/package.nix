{
  lib,
  buildGoModule,
  fetchFromGitHub,
  docker,
}:

buildGoModule rec {
  pname = "fn";
  version = "0.6.35";

  src = fetchFromGitHub {
    owner = "fnproject";
    repo = "cli";
    rev = version;
    hash = "sha256-ohT4h9w6gaOk6C3O8eUBcmXHRSzL2mcRO8RnNY8htso=";
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

  meta = with lib; {
    description = "Command-line tool for the fn project";
    mainProgram = "fn";
    homepage = "https://fnproject.io";
    license = licenses.asl20;
    maintainers = [ maintainers.c4605 ];
  };
}
