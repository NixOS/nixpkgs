{ stdenv, fetchFromGitHub, emacs, texinfo }:

stdenv.mkDerivation rec {
  name = "helm-mode-${version}";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "emacs-helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "0h6srlc1274jfgfv7hlwfwigdlyyzh6af2c3jiqsdngix1f0xs0i";
  };

  buildInputs = [ emacs texinfo ];

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp *.el *.elc $out/share/emacs/site-lisp/
  '';

  meta = with stdenv.lib; {
    homepage = "http://emacs-helm.github.com/helm";
    description = "Emacs incremental completion and selection narrowing framework";
    platforms = platforms.unix;
    maintainers = with maintainers; [ edwtjo ];
  };
}
