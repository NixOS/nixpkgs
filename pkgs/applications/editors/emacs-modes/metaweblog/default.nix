{ stdenv, fetchgit, emacs, xmlRpc }:

stdenv.mkDerivation rec {
  name = "metaweblog-0.1";

  src = fetchgit {
    url = https://github.com/punchagan/metaweblog.git;
    rev = "ceda65048afaa4c7596c7f50ced998c59ef41167";
    sha256 = "a4c10bb1b4be574e560f87d5f07da4e24e5fffe9ecc83e6d4f9325f3a7eb1e2f";
  };

  buildInputs = [ emacs ];
  propagatedUserEnvPkgs = [ xmlRpc ];

  buildPhase = ''
    emacs -L . -L ${xmlRpc}/share/emacs/site-lisp --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el* $out/share/emacs/site-lisp
  '';

  meta = {
    description = "An emacs library to access metaweblog based weblogs";
    homepage = https://github.com/punchagan/metaweblog;
    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.all;
  };
}
