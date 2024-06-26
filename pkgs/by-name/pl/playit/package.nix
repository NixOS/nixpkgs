{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "playit";
  version = "0.15.13";

  src = fetchFromGitHub {
    owner = "playit-cloud";
    repo = "playit-agent";
    rev = "v${version}";
    hash = "sha256-RRN0KAgFVXQGU6LdNWClBFlqO+Nl4SMNXDWfV0lOhAE=";
  };

  cargoHash = "sha256-PMaDU/6Y/t78uJ98qKGc+4WDX18SPN8PwLZqOqYW4yo=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  doCheck = false;

  meta = with lib; {
    description = "Program for playit, a global proxy to run an online game server";
    homepage = "https://github.com/playit-cloud/playit-agent";
    license = licenses.bsd2;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "playit-cli";
  };
}
