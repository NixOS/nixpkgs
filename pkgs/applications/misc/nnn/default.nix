{ stdenv, fetchFromGitHub, pkgconfig, ncurses, readline, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "nnn";
  version = "2.8";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = pname;
    rev = "v${version}";
    sha256 = "05c7symzy43mc3gdq9qxnwqxgf0rims4fsc30y99pcx40zb405pk";
  };

  configFile = optionalString (conf != null) (builtins.toFile "nnn.h" conf);
  preBuild = optionalString (conf != null) "cp ${configFile} nnn.h";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ readline ncurses ];

  makeFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" ];

  # shell completions
  postInstall = ''
    install -Dm555 misc/auto-completion/bash/nnn-completion.bash $out/share/bash-completion/completions/nnn.bash
    install -Dm555 misc/auto-completion/zsh/_nnn -t $out/share/zsh/site-functions
    install -Dm555 misc/auto-completion/fish/nnn.fish -t $out/share/fish/vendor_completions.d
  '';

  meta = {
    description = "Small ncurses-based file browser forked from noice";
    homepage = "https://github.com/jarun/nnn";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau filalex77 ];
  };
}
