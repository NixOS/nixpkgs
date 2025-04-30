{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  installShellFiles,
  rustPlatform,
  testers,
  cachix,
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
      rev = "b455edf3505f1bf0172b39a735caef94687d0d9c";
      hash = "sha256-bYyjarS3qSNqxfgc89IoVz8cAFDkF9yPE63EJr+h50s=";
    };
    doCheck = false;
    doInstallCheck = false;
  });

  version = "1.6";
in
rustPlatform.buildRustPackage {
  pname = "devenv";
  inherit version;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    rev = "v${version}";
    hash = "sha256-ui6UwatBHN2WFvStGUHVOdBu72MsG/7b0GeyRdTCyEw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XS6F/Sp5peJdzAormYPjAA4SJfusMH6PRYIM3Tw5AUw=";

  buildAndTestSubdir = "devenv";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    pkg-config
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
