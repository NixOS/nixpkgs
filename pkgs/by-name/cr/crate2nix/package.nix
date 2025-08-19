{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  cargo,
  nix,
  nix-prefetch-git,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "crate2nix";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "crate2nix";
    rev = version;
    hash = "sha256-esWhRnt7FhiYq0CcIxw9pvH+ybOQmWBfHYMtleaMhBE=";
  };

  sourceRoot = "${src.name}/crate2nix";

  cargoHash = "sha256-Du6RAe4Ax3KK90h6pQEtF75Wdniz+IqF2/TXHA9Ytbw=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  # Tests use nix(1), which tries (and fails) to set up /nix/var inside the sandbox.
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/crate2nix \
      --suffix PATH ":" ${
        lib.makeBinPath [
          cargo
          nix
          nix-prefetch-git
        ]
      }

      for shell in bash zsh fish
      do
        $out/bin/crate2nix completions -s $shell
        installShellCompletion crate2nix.$shell || installShellCompletion --$shell _crate2nix
      done
  '';

  meta = with lib; {
    description = "Nix build file generator for Rust crates";
    mainProgram = "crate2nix";
    longDescription = ''
      Crate2nix generates Nix files from Cargo.toml/lock files
      so that you can build every crate individually in a Nix sandbox.
    '';
    homepage = "https://github.com/nix-community/crate2nix";
    changelog = "https://nix-community.github.io/crate2nix/90_reference/90_changelog";
    license = licenses.asl20;
    maintainers = with maintainers; [
      kolloch
      cole-h
      kranzes
    ];
  };
}
