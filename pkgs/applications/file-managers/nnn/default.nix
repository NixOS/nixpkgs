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
# options
, conf ? null
, withIcons ? false
, withNerdIcons ? false
}:

# Mutually exclusive options
assert withIcons -> withNerdIcons == false;
assert withNerdIcons -> withIcons == false;

stdenv.mkDerivation rec {
  pname = "nnn";
  version = "4.6";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+EAKOXZp1kxA2X3e16ItjPT7Sa3WZuP2oxOdXkceTIY=";
  };

  configFile = lib.optionalString (conf != null) (builtins.toFile "nnn.h" conf);
  preBuild = lib.optionalString (conf != null) "cp ${configFile} src/nnn.h";

  nativeBuildInputs = [ installShellFiles makeWrapper pkg-config ];
  buildInputs = [ readline ncurses ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ]
    ++ lib.optional withIcons [ "O_ICONS=1" ]
    ++ lib.optional withNerdIcons [ "O_NERD=1" ];

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
}
