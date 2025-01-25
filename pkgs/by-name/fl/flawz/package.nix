{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  sqlite,
  installShellFiles,
  stdenv,
  buildPackages,
}:

rustPlatform.buildRustPackage rec {
  pname = "flawz";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "flawz";
    rev = "v${version}";
    hash = "sha256-7p/BUXrElJutUcRMu+LxdsMxA6lCDnaci0fDaKGsawI=";
  };

  cargoHash = "sha256-jVAMnU2NnL/2Hri6NxSUkIfQ/bJ5wMZ+oFOTMPrFE0M=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
    sqlite
  ];
  outputs = [
    "out"
    "man"
  ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
      flawz-mangen = "${emulator} $out/bin/flawz-mangen";
      flawz-completions = "${emulator} $out/bin/flawz-completions";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      export OUT_DIR=$(mktemp -d)

      # Generate the man pages
      ${flawz-mangen}
      installManPage $OUT_DIR/flawz.1

      # Generate shell completions
      ${flawz-completions}
      installShellCompletion \
        --bash $OUT_DIR/flawz.bash \
        --fish $OUT_DIR/flawz.fish \
        --zsh $OUT_DIR/_flawz

      # Clean up temporary directory
      rm -rf $OUT_DIR
      # No need for these binaries to end up in the output
      rm $out/bin/flawz-{completions,mangen}
    '';

  meta = {
    description = "Terminal UI for browsing CVEs";
    homepage = "https://github.com/orhun/flawz";
    changelog = "https://github.com/orhun/flawz/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "flawz";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
    broken = stdenv.hostPlatform.isDarwin; # needing some apple_sdk packages
  };
}
