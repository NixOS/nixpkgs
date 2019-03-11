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
  version = "unstable-2018-11-16";

  src = fetchFromGitHub {
    owner = "akermu";
    repo = "emacs-libvterm";
    rev = "8be9316156be75a685c0636258b2fec2daaf5ab5";
    sha256 = "059js4aa7xgqcpaicgy4gz683hppa1iyp1r98mnms5hd31a304k8";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ emacs libvterm-neovim ];

  cmakeFlags = [ "-DEMACS_SOURCE=${emacsSources}" ];

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install ../*.el $out/share/emacs/site-lisp
    install ./*.so $out/share/emacs/site-lisp
  '';
}
