{ stdenv, fetchFromGitHub, installShellFiles, pkgconfig, ncurses, readline, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "nnn";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h7j0wcpwwd2fibggr1nwkqpvhv2i1qnk54c4x6hixx31yidy2l0";
  };

  configFile = optionalString (conf != null) (builtins.toFile "nnn.h" conf);
  preBuild = optionalString (conf != null) "cp ${configFile} nnn.h";

  nativeBuildInputs = [ installShellFiles pkgconfig ];
  buildInputs = [ readline ncurses ];

  makeFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" ];

  # shell completions
  postInstall = ''
    installShellCompletion misc/auto-completion/bash/nnn-completion.bash
    installShellCompletion misc/auto-completion/zsh/_nnn
    installShellCompletion misc/auto-completion/fish/nnn.fish
  '';

  meta = {
    description = "Small ncurses-based file browser forked from noice";
    homepage = "https://github.com/jarun/nnn";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau filalex77 ];
  };
}
