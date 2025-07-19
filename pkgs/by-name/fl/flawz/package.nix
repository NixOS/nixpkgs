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

  useFetchCargoVendor = true;
  cargoHash = "sha256-X2RyavcPOQzuAt347KxfmNtO4YsFdncwUcBWtMfxaRU=";

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

  postInstall = ''
    ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform)
      # bash
      ''
        export OUT_DIR=$(mktemp -d)

        # Generate the man pages
        $out/bin/flawz-mangen
        installManPage $OUT_DIR/flawz.1

        # Generate shell completions
        $out/bin/flawz-completions
        installShellCompletion \
          --bash $OUT_DIR/flawz.bash \
          --fish $OUT_DIR/flawz.fish \
          --zsh $OUT_DIR/_flawz

        # Clean up temporary directory
        rm -rf $OUT_DIR
      ''
    }
    ${lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform)
      # bash
      ''
        # copy man pages and shell completions from buildPackage
        mkdir -p $out/share $man/share/man
        cp -rp ${buildPackages.flawz}/share $out
        cp -rp ${buildPackages.flawz.man}/share $man
      ''
    }
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
  };
}
