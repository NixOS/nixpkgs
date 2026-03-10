{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  pname = "oathkeeper";
  version = "25.4.0";
  commit = "2020997ed914fbc8c4b048effbe28841c34ac23d";
in
buildGoModule {
  inherit pname version commit;

  src = fetchFromGitHub {
    owner = "ory";
    repo = "oathkeeper";
    rev = "v${version}";
    hash = "sha256-J+76oQbm/CulzfJOhXVzlXWNtpl7PaEJPM96p1ko3Cg=";
  };

  vendorHash = "sha256-YNpWjDOcjELCpNcxmd8eatMvPUTHos52yvDg4jsHAQk=";

  tags = [
    "sqlite"
    "json1"
    "hsm"
  ];

  subPackages = [ "." ];

  # Pass versioning information via ldflags
  ldflags = [
    "-s"
    "-w"
    "-X github.com/ory/oathkeeper/x.Version=${version}"
    "-X github.com/ory/oathkeeper/x.Commit=${commit}"
  ];

  meta = {
    description = "Open-source identity and access proxy that authorizes HTTP requests based on sets of rules";
    homepage = "https://www.ory.sh/oathkeeper/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      camcalaquian
      debtquity
    ];
    mainProgram = "oathkeeper";
  };
}
