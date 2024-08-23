{
  lib,
  darwin,
  fetchFromGitHub,
  libiconv,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  testers,
}:

let
  inherit (darwin.apple_sdk.frameworks) Security;
  self = rustPlatform.buildRustPackage {
    pname = "so";
    version = "0.4.9";

    src = fetchFromGitHub {
      owner = "samtay";
      repo = "so";
      rev = "v${self.version}";
      hash = "sha256-4IZNOclQj3ZLE6WRddn99CrV8OoyfkRBXnA4oEyMxv8=";
    };

    cargoHash = "sha256-hHXA/n/HQeBaD4QZ2b6Okw66poBRwNTpQWF0qBhLp/o=";

    nativeBuildInputs = [ pkg-config ];

    buildInputs =
      [ openssl ]
      ++ lib.optionals stdenv.isDarwin [
        libiconv
        Security
      ];

    strictDeps = true;

    passthru = {
      tests = {
        version = testers.testVersion {
          package = self;
          command = ''
            export HOME=$TMP
            so --version
          '';
        };
      };
    };

    meta = {
      homepage = "https://github.com/samtay/so";
      description = "TUI to StackExchange network";
      changelog = "https://github.com/samtay/so/blob/main/CHANGELOG.md";
      mainProgram = "so";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ AndersonTorres ];
    };
  };
in
self
