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
  devenv_nix =
    (nixVersions.git.overrideSource (fetchFromGitHub {
      owner = "cachix";
      repo = "nix";
      rev = "afa41b08df4f67b8d77a8034b037ac28c71c77df";
      hash = "sha256-IDB/oh/P63ZTdhgSkey2LZHzeNhCdoKk+4j7AaPe1SE=";
    })).overrideAttrs
      (old: {
        version = "2.30-devenv";
        doCheck = false;
        doInstallCheck = false;
        # do override src, but the Nix way so the warning is unaware of it
        __intentionallyOverridingVersion = true;
      });

  version = "1.7";
in
rustPlatform.buildRustPackage {
  pname = "devenv";
  inherit version;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    tag = "v${version}";
    hash = "sha256-LzMVgB8izls/22g69KvWPbuQ8C7PRT9PobbvdV3/raI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-k/UrnRTI+Z09kdN7PYNOg9+GnumqOdm36F31CKZCGMU=";

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
