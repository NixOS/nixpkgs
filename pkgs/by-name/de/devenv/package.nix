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
  dbus,
  pkg-config,
  glibcLocalesUtf8,
  devenv, # required to run version test
}:

let
  devenv_nix =
    (nixVersions.git.overrideSource (fetchFromGitHub {
      owner = "cachix";
      repo = "nix";
      rev = "031c3cf42d2e9391eee373507d8c12e0f9606779";
      hash = "sha256-dOi/M6yNeuJlj88exI+7k154z+hAhFcuB8tZktiW7rg=";
    })).overrideAttrs
      (old: {
        version = "2.30-devenv";
        doCheck = false;
        doInstallCheck = false;
        # do override src, but the Nix way so the warning is unaware of it
        __intentionallyOverridingVersion = true;
      });

  version = "1.8.1";
in
rustPlatform.buildRustPackage {
  pname = "devenv";
  inherit version;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    tag = "v${version}";
    hash = "sha256-YsSFlVWUu4RSYnObqcBJ4Mr3bJVVhuFhaQAktHytBAI=";
  };

  cargoHash = "sha256-zJorGAsp5k5oBuXogYqEPVexcNsYCeiTmrQqySd1AGs=";

  buildAndTestSubdir = "devenv";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    openssl
    dbus
  ];

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
