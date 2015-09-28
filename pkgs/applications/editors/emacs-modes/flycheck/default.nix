{ stdenv, fetchFromGitHub, emacs, let-alist, dash, texinfo }:

stdenv.mkDerivation rec {
  name = "flycheck-0.22-64-g90dbc2d";

  src = fetchFromGitHub {
    owner = "flycheck";
    repo = "flycheck";
    rev = "90dbc2d";
    sha256 = "08bg4jps6hjldbcrvqarrwdv4xzirm5pns5s0331wm0sc47yvbli";
  };

  buildInputs = [ emacs texinfo ];

  buildPhase = ''
    emacs -L ${let-alist}/share/emacs/site-lisp -L ${dash}/share/emacs/site-lisp --batch -f batch-byte-compile flycheck.el
    makeinfo --force --no-split -o doc/flycheck.info doc/flycheck.texi
  '';

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp $out/share/info
    mv flycheck.el flycheck.elc $out/share/emacs/site-lisp/
    mv "doc/"*.info $out/share/info/
  '';

  meta = {
    inherit (src.meta) homepage;
    description = "Modern on-the-fly syntax checking for GNU Emacs";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ simons ];
  };
}
