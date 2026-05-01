{
  lib,
  stdenv,
  fetchurl,
  emacs,
  texliveBasic,
  ghostscript,
}:

let
  auctex = stdenv.mkDerivation rec {
    # Make this a valid tex(live-new) package;
    # the pkgs attribute is provided with a hack below.
    pname = "auctex";
    version = "13.2";
    tlType = "run";

    outputs = [
      "out"
      "tex"
    ];

    src = fetchurl {
      url = "mirror://gnu/auctex/auctex-${version}.tar.gz";
      hash = "sha256-Hn5AKrz4RmlOuncZklvwlcI+8zpeZgIgHHS2ymCUQDU=";
    };

    buildInputs = [
      emacs
      ghostscript
      (texliveBasic.withPackages (ps: [
        ps.etoolbox
        ps.hypdoc
      ]))
    ];

    preConfigure = ''
      mkdir -p "$tex"
      export HOME=$(mktemp -d)
    '';

    configureFlags = [
      "--with-lispdir=\${out}/share/emacs/site-lisp"
      "--with-texmf-dir=\${tex}"
    ];

    meta = {
      homepage = "https://www.gnu.org/software/auctex";
      description = "Extensible package for writing and formatting TeX files in GNU Emacs and XEmacs";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.unix;
    };
  };

in
auctex // { pkgs = [ auctex.tex ]; }
