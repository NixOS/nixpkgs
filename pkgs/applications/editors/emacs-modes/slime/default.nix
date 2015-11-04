{stdenv, fetchFromGitHub, emacs}:

stdenv.mkDerivation rec {
  name = "slime";
  src = fetchFromGitHub {
    owner = "slime";
    repo = "slime";
    rev = "f80c997ee9408a73637057759120c5b37b55d781";
    sha256 = "06ncqxzidmis6d7xsyi5pamg4pvifmc8l854xaa847rhagsvw7ax";
  };
  buildInputs = [emacs];
  installPhase = ''
    rm -rf CVS
    mkdir -p $out/share/emacs/site-lisp
    cp -r . $out/share/emacs/site-lisp
  '';
  meta = {
    homepage = "https://common-lisp.net/project/slime/";
    description = "The Superior Lisp Interaction Mode for Emacs";
    license = "GPL";
  };
}
