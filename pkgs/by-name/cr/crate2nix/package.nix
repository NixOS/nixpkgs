{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, cargo
, nix
, nix-prefetch-git
, installShellFiles
,
}:

rustPlatform.buildRustPackage rec {
  pname = "crate2nix";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = version;
    hash = "sha256-esWhRnt7FhiYq0CcIxw9pvH+ybOQmWBfHYMtleaMhBE=";
  };

  sourceRoot = "${src.name}/${pname}";

  cargoHash = "sha256-nQ1VUCFMmpWZWvKFbyJFIZUJ24N9ZPY8JCHWju385NE=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  # Tests use nix(1), which tries (and fails) to set up /nix/var inside the sandbox.
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/${pname} \
      --prefix PATH ":" ${
        lib.makeBinPath [
          cargo
          nix
          nix-prefetch-git
        ]
      }

      for shell in bash zsh fish
      do
        $out/bin/${pname} completions -s $shell
        installShellCompletion ${pname}.$shell || installShellCompletion --$shell _${pname}
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
