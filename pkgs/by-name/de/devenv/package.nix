{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  gitMinimal,
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
  version = "1.11.2";
  devenvNixVersion = "2.30.4";

  devenv_nix =
    let
      components = (
        nixVersions.nixComponents_git.overrideSource (fetchFromGitHub {
          owner = "cachix";
          repo = "nix";
          rev = "devenv-${devenvNixVersion}";
          hash = "sha256-3+GHIYGg4U9XKUN4rg473frIVNn8YD06bjwxKS1IPrU=";
        })
      );
    in
    # Support for mdbook >= 0.5, https://github.com/NixOS/nix/issues/14628
    (
      (components.appendPatches [
        (fetchpatch2 {
          name = "nix-2.30-14695-mdbook-0.5-support.patch";
          url = "https://github.com/NixOS/nix/commit/5cbd7856de0a9c13351f98e32a1e26d0854d87fd.patch";
          excludes = [ "doc/manual/package.nix" ];
          hash = "sha256-GYaTOG9wZT9UI4G6za535PkLyjHKSxwBjJsXbjmI26g=";
        })
      ]).overrideScope
      (
        finalScope: prevScope: {
          version = devenvNixVersion;
        }
      )
    ).nix-everything.overrideAttrs
      (old: {
        pname = "devenv-nix";
        version = devenvNixVersion;
        doCheck = false;
        doInstallCheck = false;
        # do override src, but the Nix way so the warning is unaware of it
        __intentionallyOverridingVersion = true;
      });
in
rustPlatform.buildRustPackage {
  pname = "devenv";
  inherit version;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    tag = "v${version}";
    hash = "sha256-8Ivbm9ltg0hUGQYMuRDOI8hbHUzqB9xKZ9ubKAzzwE8=";
  };

  cargoHash = "sha256-mMmobDZeNqrByowwrDXojVnHeUyC/YbhERpF8iOCZ0s=";

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
    maintainers = with lib.maintainers; [
      domenkozar
      sandydoo
    ];
  };
}
