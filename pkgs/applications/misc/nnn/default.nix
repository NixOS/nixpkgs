{ stdenv, fetchFromGitHub, pkgconfig, ncurses, readline, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "nnn-${version}";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "nnn";
    rev = "v${version}";
    sha256 = "0y55h5pxd20qw2ajhz8fsk45aynx0xzgr9kfr545hyhmfkg2nc49";
  };

  configFile = optionalString (conf!=null) (builtins.toFile "nnn.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} nnn.h";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ readline ncurses ];

  makeFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" ];

  # shell completions
  postInstall = ''
    install -Dm555 scripts/auto-completion/bash/nnn-completion.bash $out/share/bash-completion/completions/nnn.bash
    install -Dm555 scripts/auto-completion/zsh/_nnn -t $out/share/zsh/site-functions
    install -Dm555 scripts/auto-completion/fish/nnn.fish -t $out/share/fish/vendor_completions.d
  '';

  meta = {
    description = "Small ncurses-based file browser forked from noice";
    homepage = https://github.com/jarun/nnn;
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
