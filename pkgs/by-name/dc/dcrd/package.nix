{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule (finalAttrs: {
  pname = "dcrd";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-9w3M2XlvylmdUmQOORTra9qxqLpsgnVzA7lk+Z1Qa5Q=";
  };

  vendorHash = "sha256-oKlZnzW36BDJ0qpVSoJOLVhprd5iW6ZAt12Ifdf+FHQ=";

  subPackages = [
    "."
    "cmd/promptsecret"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export DCRD_APPDATA="$TMPDIR"
  '';

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ juaningan ];
  };
})
