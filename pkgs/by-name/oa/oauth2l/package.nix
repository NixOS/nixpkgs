{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oauth2l";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "oauth2l";
    rev = "v${version}";
    hash = "sha256-bL1bys/CBo/P9VfWc/FB8JHW/aBwC521V8DB1sFBIAA=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = "export HOME=$(mktemp -d)";

  # tests fail on linux for some reason
  doCheck = stdenv.isDarwin;

  meta = with lib; {
    description = "Simple CLI for interacting with Google API authentication";
    homepage = "https://github.com/google/oauth2l";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "oauth2l";
  };
}
