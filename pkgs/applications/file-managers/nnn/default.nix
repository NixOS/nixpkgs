{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, installShellFiles
, makeWrapper
, pkg-config
, file
, ncurses
, readline
, which
, musl-fts
  # options
, conf ? null
, withIcons ? false
, withNerdIcons ? false
, withEmojis ? false
}:

# Mutually exclusive options
assert withIcons -> (withNerdIcons == false && withEmojis == false);
assert withNerdIcons -> (withIcons == false && withEmojis == false);
assert withEmojis -> (withIcons == false && withNerdIcons == false);

stdenv.mkDerivation (finalAttrs: {
  pname = "nnn";
  version = "4.8";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "nnn";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QbKW2wjhUNej3zoX18LdeUHqjNLYhEKyvPH2MXzp/iQ=";
  };

  patches = [
    # Nix-specific: ensure nnn passes correct arguments to the Nix file command on Darwin.
    # By default, nnn expects the macOS default file command, not the one provided by Nix.
    # However, both commands use different arguments to obtain the MIME type.
    ./darwin-fix-file-mime-opts.patch
    # FIXME: remove for next release
    (fetchpatch {
      url = "https://github.com/jarun/nnn/commit/20e944f5e597239ed491c213a634eef3d5be735e.patch";
      hash = "sha256-RxG3AU8i3lRPCjRVZPnej4m1No/SKtsHwbghj9JQ7RQ=";
    })
  ];

  configFile = lib.optionalString (conf != null) (builtins.toFile "nnn.h" conf);
  preBuild = lib.optionalString (conf != null) "cp ${finalAttrs.configFile} src/nnn.h";

  nativeBuildInputs = [ installShellFiles makeWrapper pkg-config ];
  buildInputs = [ readline ncurses ] ++ lib.optional stdenv.hostPlatform.isMusl musl-fts;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isMusl "-I${musl-fts}/include";
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isMusl "-lfts";

  makeFlags = [ "PREFIX=$(out)" ]
    ++ lib.optionals withIcons [ "O_ICONS=1" ]
    ++ lib.optionals withNerdIcons [ "O_NERD=1" ]
    ++ lib.optionals withEmojis [ "O_EMOJI=1" ];

  binPath = lib.makeBinPath [ file which ];

  installTargets = [ "install" "install-desktop" ];

  postInstall = ''
    installShellCompletion --bash --name nnn.bash misc/auto-completion/bash/nnn-completion.bash
    installShellCompletion --fish misc/auto-completion/fish/nnn.fish
    installShellCompletion --zsh misc/auto-completion/zsh/_nnn

    wrapProgram $out/bin/nnn --prefix PATH : "$binPath"
  '';

  meta = with lib; {
    description = "Small ncurses-based file browser forked from noice";
    homepage = "https://github.com/jarun/nnn";
    changelog = "https://github.com/jarun/nnn/blob/v${version}/CHANGELOG";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau Br1ght0ne ];
    mainProgram = "nnn";
  };
})
