{ stdenv, fetchFromGitHub, cmake, emacs, libvterm-neovim }:

let
  emacsSources = stdenv.mkDerivation {
    name = emacs.name + "-sources";
    src = emacs.src;

    configurePhase = ":";
    dontBuild = true;
    doCheck = false;
    fixupPhase = ":";

    installPhase = ''
      mkdir -p $out
      cp -a * $out
    '';

  };

in stdenv.mkDerivation rec {
  name = "emacs-libvterm-${version}";
  version = "unstable-2017-11-24";

  src = fetchFromGitHub {
    owner = "akermu";
    repo = "emacs-libvterm";
    rev = "829ae86f60c3a54048804997edffa161c77a2f4b";
    sha256 = "1xb24kpvypvskh4vr3b45nl2m2vsczcr9rnsr2sjzf32mnapyjnp";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ emacs libvterm-neovim ];

  cmakeFlags = [ "-DEMACS_SOURCE=${emacsSources}" ];

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install ../*.el $out/share/emacs/site-lisp
    install ../*.so $out/share/emacs/site-lisp
  '';
}
