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
  inherit (darwin.apple_sdk.frameworks) CoreServices Security SystemConfiguration;
  self = rustPlatform.buildRustPackage {
    pname = "so";
    version = "0.4.10";

    src = fetchFromGitHub {
      pname = "so-source";
      inherit (self) version;
      owner = "samtay";
      repo = "so";
      rev = "v${self.version}";
      hash = "sha256-25jZEo1C9XF4m9YzDwtecQy468nHyv2wnRuK5oY2siU=";
    };

    cargoHash = "sha256-F9DNY0jKhH6aQRqlXq6MEMoFa1qtvAdL5lSEsql6gcI=";

    nativeBuildInputs = [ pkg-config ];

    buildInputs =
      [ openssl ]
      ++ lib.optionals stdenv.isDarwin [
        libiconv
        CoreServices
        Security
        SystemConfiguration
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
      maintainers = with lib.maintainers; [
        AndersonTorres
        unsolvedcypher
      ];
    };
  };
in
self
