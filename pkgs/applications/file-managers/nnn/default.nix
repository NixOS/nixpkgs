{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  pkg-config,
  file,
  ncurses,
  readline,
  which,
  musl-fts,
  pcre,
  # options
  conf ? null,
  withIcons ? false,
  withNerdIcons ? false,
  withEmojis ? false,
  withPcre ? false,
  extraMakeFlags ? [ ],
}:

# Mutually exclusive options
assert withIcons -> (withNerdIcons == false && withEmojis == false);
assert withNerdIcons -> (withIcons == false && withEmojis == false);
assert withEmojis -> (withIcons == false && withNerdIcons == false);

stdenv.mkDerivation (finalAttrs: {
  pname = "nnn";
  version = "4.9";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "nnn";
    rev = "v${finalAttrs.version}";
    hash = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
  };

  patches = [
    # Nix-specific: ensure nnn passes correct arguments to the Nix file command on Darwin.
    # By default, nnn expects the macOS default file command, not the one provided by Nix.
    # However, both commands use different arguments to obtain the MIME type.
    ./darwin-fix-file-mime-opts.patch
  ];

  configFile = lib.optionalString (conf != null) (builtins.toFile "nnn.h" conf);
  preBuild = lib.optionalString (conf != null) "cp ${finalAttrs.configFile} src/nnn.h";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];
  buildInputs =
    [
      readline
      ncurses
    ]
    ++ lib.optional stdenv.hostPlatform.isMusl musl-fts
    ++ lib.optional withPcre pcre;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isMusl "-I${musl-fts}/include";
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isMusl "-lfts";

  makeFlags =
    [ "PREFIX=$(out)" ]
    ++ lib.optionals withIcons [ "O_ICONS=1" ]
    ++ lib.optionals withNerdIcons [ "O_NERD=1" ]
    ++ lib.optionals withEmojis [ "O_EMOJI=1" ]
    ++ lib.optionals withPcre [ "O_PCRE=1" ]
    ++ extraMakeFlags;

  binPath = lib.makeBinPath [
    file
    which
  ];

  installTargets = [
    "install"
    "install-desktop"
  ];

  postInstall = ''
    installShellCompletion --bash --name nnn.bash misc/auto-completion/bash/nnn-completion.bash
    installShellCompletion --fish misc/auto-completion/fish/nnn.fish
    installShellCompletion --zsh misc/auto-completion/zsh/_nnn

    cp -r plugins $out/share
    cp -r misc/quitcd $out/share/quitcd

    wrapProgram $out/bin/nnn --prefix PATH : "$binPath"
  '';

  meta = with lib; {
    description = "Small ncurses-based file browser forked from noice";
    homepage = "https://github.com/jarun/nnn";
    changelog = "https://github.com/jarun/nnn/blob/v${finalAttrs.version}/CHANGELOG";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "nnn";
  };
})
