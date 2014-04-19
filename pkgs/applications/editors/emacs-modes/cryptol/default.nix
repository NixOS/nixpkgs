{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation rec {
  name    = "cryptol-mode-${version}";
  version = "20141010";

  src = fetchgit {
    url    = "https://github.com/thoughtpolice/cryptol-mode.git";
    rev    = "50075d49d7c4ec4b03ce31b634424410262c1ad4";
    sha256 = "6ecd4904b7f3b1cd0721591ce45f16fe11cd1dd5fd7af8110d1f84b133ed4aec";
  };

  buildInputs = [ emacs ];

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Emacs major mode for Cryptol";
    homepage    = "https://thoughtpolice/cryptol-mode";
    license     = stdenv.lib.licenses.gpl3Plus;
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
