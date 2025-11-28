{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  installShellFiles,
  rustPackages_1_89,
  testers,
  cachix,
  nixVersions,
  gitMinimal,
  openssl,
  dbus,
  pkg-config,
  glibcLocalesUtf8,
  devenv, # required to run version test
}:

let
  version = "1.11.1";
  devenvNixVersion = "2.30.4";

  devenv_nix =
    (nixVersions.git.overrideSource (fetchFromGitHub {
      owner = "cachix";
      repo = "nix";
      rev = "devenv-${devenvNixVersion}";
      hash = "sha256-3+GHIYGg4U9XKUN4rg473frIVNn8YD06bjwxKS1IPrU=";
    })).overrideAttrs
      (old: {
        pname = "devenv-nix";
        version = devenvNixVersion;
        doCheck = false;
        doInstallCheck = false;
        # do override src, but the Nix way so the warning is unaware of it
        __intentionallyOverridingVersion = true;
      });
in
rustPackages_1_89.rustPlatform.buildRustPackage {
  pname = "devenv";
  inherit version;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    tag = "v${version}";
    hash = "sha256-xfvW7aF2bDXDXzUeaSOXE+bARfcDbf4YCMVfNp8DTv0=";
  };

  cargoHash = "sha256-jv/JwSdVMvL5ymO/1NxLNGbJ2Ly2QrVLGQHNTnSPpc0=";

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

  nativeCheckInputs = [
    gitMinimal
  ];

  preCheck = ''
    git init
    git config user.email "test@example.com"
    git config user.name "Test User"
  '';

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
