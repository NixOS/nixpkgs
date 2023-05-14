{ lib
, stdenv
, fetchFromGitHub
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
}:

# Mutually exclusive options
assert withIcons -> withNerdIcons == false;
assert withNerdIcons -> withIcons == false;

stdenv.mkDerivation (finalAttrs: {
  pname = "nnn";
  version = "4.8";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "nnn";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QbKW2wjhUNej3zoX18LdeUHqjNLYhEKyvPH2MXzp/iQ=";
  };

  configFile = lib.optionalString (conf != null) (builtins.toFile "nnn.h" conf);
  preBuild = lib.optionalString (conf != null) "cp ${finalAttrs.configFile} src/nnn.h";

  nativeBuildInputs = [ installShellFiles makeWrapper pkg-config ];
  buildInputs = [ readline ncurses ] ++ lib.optional stdenv.hostPlatform.isMusl musl-fts;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isMusl "-I${musl-fts}/include";
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isMusl "-lfts";

  makeFlags = [ "PREFIX=$(out)" ]
    ++ lib.optionals withIcons [ "O_ICONS=1" ]
    ++ lib.optionals withNerdIcons [ "O_NERD=1" ];

  binPath = lib.makeBinPath [ file which ];

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
  };
})
