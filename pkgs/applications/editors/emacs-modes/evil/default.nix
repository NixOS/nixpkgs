{ stdenv, fetchFromGitorious, emacs, texinfo }:

stdenv.mkDerivation rec {
  name = "evil-mode-${version}";
  version = "1.0.9";

  src = fetchFromGitorious rec {
    owner = "evil";
    repo = owner;
    rev = version;
    #sha256 = "19flq0kfnwymh9dx3klsgbfnypsa85a82kxhmg3ayljhxp9g2qa2";
    sha256 = "0frx1jp9ik7lpgrdbigxfyg0xv8r4bjgnzzi1wgdgir76rn6l9rm";
  };

  buildInputs = [ emacs texinfo ];

  buildPhase = "make VERSION=${version} && cd doc && makeinfo evil.texi && cd -";

  installPhase = ''
    mkdir -p $out/share/{emacs/site-lisp,info}
    cp *.el *.elc $out/share/emacs/site-lisp/
    cp -v doc/evil.info $out/share/info/.
  '';

  meta = with stdenv.lib; {
    homepage = "https://gitorious.org/evil/evil/";
    description = "Evil mode for Emacs";
    platforms = platforms.unix;
    maintainers = with maintainers; [ edwtjo ];
  };
}
