{
  lib,
  fetchFromGitHub,
  libiconv,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  testers,
}:

let
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

    cargoHash = "sha256-cSLsfYYtdMiXGCG3jpq2Cxl8TgSb7iCWoeXNwEuv4FM=";

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
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
        unsolvedcypher
      ];
    };
  };
in
self
