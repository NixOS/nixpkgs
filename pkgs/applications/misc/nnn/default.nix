{ stdenv, fetchFromGitHub, pkgconfig, ncurses, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "nnn-${version}";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "nnn";
    rev = "v${version}";
    sha256 = "01y2vkw1wakpnpzhzia3d44iir060i8vma3b3ww5wgwg7bfpzs4b";
  };

  configFile = optionalString (conf!=null) (builtins.toFile "nnn.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} nnn.h";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses ];

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
