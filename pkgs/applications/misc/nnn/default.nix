{ stdenv, fetchFromGitHub, pkgconfig, ncurses, readline, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "nnn";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dxa5blpdf0s03znhnr23zzpsz8yzqpnwknycz42h1w9g9s9jz1v";
  };

  configFile = optionalString (conf != null) (builtins.toFile "nnn.h" conf);
  preBuild = optionalString (conf != null) "cp ${configFile} src/nnn.h";

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
