{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  pname = "oathkeeper";
  version = "26.2.0";
  commit = "c84dbe07ecbf6f10154f04ec49b137a115155289";
in
buildGoModule {
  inherit pname version commit;

  src = fetchFromGitHub {
    owner = "ory";
    repo = "oathkeeper";
    rev = "v${version}";
    hash = "sha256-Dux9g5AWnbj9kXoIogVneOYywgg9TnyXqP41YT/1C8k=";
  };

  vendorHash = "sha256-/Qgdes8EAxP9FDKbahQdCpAD7PSe4iCkUvL1+poqaWc=";

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
