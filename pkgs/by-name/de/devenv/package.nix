{
  lib,
  stdenv,
  fetchFromGitHub,
  gitMinimal,
  makeBinaryWrapper,
  installShellFiles,
  rustPlatform,
  testers,
  cachix,
  nixVersions,
  openssl,
  dbus,
  protobuf,
  sqlite,
  pkg-config,
  glibcLocalesUtf8,
  boehmgc,
  llvmPackages,
  nixd,
  bash,
  devenv, # required to run version test
}:

let
  version = "2.0.6";
  devenvNixVersion = "2.32";
  devenvNixRev = "e127c1c94cefe02d8ca4cca79ef66be4c527510e";

  nix_components =
    (nixVersions.nixComponents_git.overrideSource (fetchFromGitHub {
      owner = "cachix";
      repo = "nix";
      rev = devenvNixRev;
      hash = "sha256-MRNVInSmvhKIg3y0UdogQJXe+omvKijGszFtYpd5r9k=";
    })).overrideScope
      (
        finalScope: prevScope: {
          version = devenvNixVersion;
        }
      );
in
rustPlatform.buildRustPackage {
  pname = "devenv";
  inherit version;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    tag = "v${version}";
    hash = "sha256-i1G6n/7Z5fO9RhplzXQSTiLyh1Cs0GhoCoEStFLARtA=";
  };

  cargoHash = "sha256-p5kI7HlG6RVxCCEb/J0L2gh36jkm/atAV98ny3h4vqo=";

  # Upstream tagged v2.0.6 with Cargo.toml already bumped to 2.0.7
  postPatch = ''
    substituteInPlace Cargo.toml --replace-fail 'version = "2.0.7"' 'version = "${version}"'
  '';

  env = {
    RUSTFLAGS = "--cfg tracing_unstable";
    LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";
    DEVENV_IS_RELEASE = true;
  };

  cargoBuildFlags = [
    "-p"
    "devenv"
    "-p"
    "devenv-run-tests"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    sqlite
    dbus
    llvmPackages.clang-unwrapped
    nix_components.nix-expr-c
    nix_components.nix-store-c
    nix_components.nix-util-c
    nix_components.nix-flake-c
    nix_components.nix-cmd-c
    nix_components.nix-fetchers-c
    nix_components.nix-main-c
  ];

  nativeCheckInputs = [
    gitMinimal
    bash
  ];

  preCheck = ''
    # Initialize git repo for tests that use git-root-relative imports
    pushd $NIX_BUILD_TOP/source
    git init -b main
    git config user.email "test@example.com"
    git config user.name "Test User"
    git add -A
    popd
  '';

  useNextest = true;
  cargoTestFlags = [
    "-p"
    "devenv"
  ];

  postInstall =
    let
      setDefaultLocaleArchive = lib.optionalString (glibcLocalesUtf8 != null) ''
        --set-default LOCALE_ARCHIVE ${glibcLocalesUtf8}/lib/locale/locale-archive
      '';
    in
    ''
      wrapProgram $out/bin/devenv \
        --prefix PATH ":" "$out/bin:${lib.getBin cachix}/bin:${lib.getBin nixd}/bin" \
        ${setDefaultLocaleArchive}

      wrapProgram $out/bin/devenv-run-tests \
        --prefix PATH ":" "$out/bin:${lib.getBin cachix}/bin:${lib.getBin nixd}/bin" \
        ${setDefaultLocaleArchive}

      # Generate manpages
      cargo xtask generate-manpages --out-dir man
      installManPage man/*

      # Generate shell completions (devenv must be in PATH)
      compdir=./completions
      export PATH="$out/bin:$PATH"
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
    changelog = "https://github.com/cachix/devenv/releases";
    description = "Fast, Declarative, Reproducible, and Composable Developer Environments";
    homepage = "https://github.com/cachix/devenv";
    license = lib.licenses.asl20;
    mainProgram = "devenv";
    maintainers = with lib.maintainers; [
      domenkozar
      sandydoo
    ];
  };
}
