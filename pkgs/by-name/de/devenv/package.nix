{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  installShellFiles,
  rustPlatform,
  testers,
  cachix,
  sqlx-cli,
  nixVersions,
  openssl,
  pkg-config,
  glibcLocalesUtf8,
  devenv, # required to run version test
}:

let
  devenv_nix = nixVersions.nix_2_24.overrideAttrs (old: {
    version = "2.24-devenv";
    src = fetchFromGitHub {
      owner = "domenkozar";
      repo = "nix";
      rev = "f6c5ae4c1b2e411e6b1e6a8181cc84363d6a7546";
      hash = "sha256-X8ES7I1cfNhR9oKp06F6ir4Np70WGZU5sfCOuNBEwMg=";
    };
    doCheck = false;
    doInstallCheck = false;
  });

  version = "1.3.1";
in
rustPlatform.buildRustPackage {
  pname = "devenv";
  inherit version;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    rev = "v${version}";
    hash = "sha256-FhlknassIb3rKEucqnfFAzgny1ANmenJcTyRaXYwbA0=";
  };

  cargoHash = "sha256-dJ8A2kVXkpJcRvMLE/IawFUZNJqok/IRixTRGtLsE3w=";

  buildAndTestSubdir = "devenv";

  # Force sqlx to use the prepared queries
  SQLX_OFFLINE = true;
  # A local database to use for preparing queries
  DATABASE_URL = "sqlite:nix-eval-cache.db";

  preBuild = ''
    cargo sqlx database setup --source devenv-eval-cache/migrations
    cargo sqlx prepare --workspace
  '';

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    pkg-config
    sqlx-cli
  ];

  buildInputs = [ openssl ];

  postInstall =
    let
      setDefaultLocaleArchive = lib.optionalString (glibcLocalesUtf8 != null) ''
        --set-default LOCALE_ARCHIVE ${glibcLocalesUtf8}/lib/locale/locale-archive
      '';
    in
    ''
      wrapProgram $out/bin/devenv \
        --prefix PATH ":" "$out/bin:${cachix}/bin" \
        --set DEVENV_NIX ${devenv_nix} \
        ${setDefaultLocaleArchive}

      # Generate manpages
      cargo xtask generate-manpages --out-dir man
      installManPage man/*

      # Generate shell completions
      compdir=./completions
      for shell in bash fish zsh; do
        cargo xtask generate-shell-completion $shell --out-dir $compdir
      done

      installShellCompletion --cmd devenv \
        --bash $compdir/devenv.bash \
        --fish $compdir/devenv.fish \
        --zsh $compdir/_devenv
    '';

  passthru.tests = {
    version = testers.testVersion {
      package = devenv;
      command = "export XDG_DATA_HOME=$PWD; devenv version";
    };
  };

  meta = {
    changelog = "https://github.com/cachix/devenv/releases/tag/v${version}";
    description = "Fast, Declarative, Reproducible, and Composable Developer Environments";
    homepage = "https://github.com/cachix/devenv";
    license = lib.licenses.asl20;
    mainProgram = "devenv";
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}
