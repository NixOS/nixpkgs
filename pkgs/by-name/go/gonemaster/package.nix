{
  lib,
  buildGoModule,
  fetchFromGitea,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "gonemaster";
  version = "1.6.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "pawal";
    repo = "gonemaster";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ufoyusyQY5jm9zbs75ukehLgOt73Q5w6f2AAa/PqnO0=";
  };

  vendorHash = "sha256-ASrTpOUURL0bEPrUVsidrj0SMrDamNHvW6M2cjl6brI=";

  __structuredAttrs = true;

  subPackages = [
    "cmd/gonemaster"
    "cmd/gonemaster-server"
    "cmd/gonemaster-client"
    "cmd/gonemaster-nagios"
    "cmd/gonemaster-mcp"
  ];

  # Disable the embedded web UIs in gonemaster-server (requires npm/Node).
  tags = [ "nogui" ];

  # Tests require network access for live DNS queries.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Go implementation of the Zonemaster DNS test engine";
    homepage = "https://codeberg.org/pawal/gonemaster";
    changelog = "https://codeberg.org/pawal/gonemaster/src/tag/v${finalAttrs.version}/Changelog";
    license = lib.licenses.bsd2;
    mainProgram = "gonemaster";
    maintainers = with lib.maintainers; [ tomfitzhenry ];
  };
})
