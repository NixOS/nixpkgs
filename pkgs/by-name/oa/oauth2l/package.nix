{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "oauth2l";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "oauth2l";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k1dj1bYZDQCDWOKSnEHX2dcFnlJo+2mH4U7ZEoni3FY=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = "export HOME=$(mktemp -d)";

  # tests fail on linux for some reason
  doCheck = stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Simple CLI for interacting with Google API authentication";
    homepage = "https://github.com/google/oauth2l";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "oauth2l";
  };
})
