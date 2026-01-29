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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "crate2nix";
    rev = version;
    hash = "sha256-SUuruvw1/moNzCZosHaa60QMTL+L9huWdsCBN6XZIic=";
  };

  sourceRoot = "${src.name}/crate2nix";

  cargoHash = "sha256-q/nPKNXZ1eJijeTBXA6Uuz235p+Q1uilXY5a/s8btMM=";

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

    $out/bin/crate2nix completions -s bash
    $out/bin/crate2nix completions -s zsh
    $out/bin/crate2nix completions -s fish
    installShellCompletion --bash crate2nix.bash --zsh _crate2nix --fish crate2nix.fish
  '';

  meta = {
    description = "Nix build file generator for Rust crates";
    mainProgram = "crate2nix";
    longDescription = ''
      Crate2nix generates Nix files from Cargo.toml/lock files
      so that you can build every crate individually in a Nix sandbox.
    '';
    homepage = "https://github.com/nix-community/crate2nix";
    changelog = "https://nix-community.github.io/crate2nix/90_reference/90_changelog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kolloch
      cole-h
    ];
  };
}
