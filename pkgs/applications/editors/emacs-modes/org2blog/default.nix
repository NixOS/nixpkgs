{ stdenv, fetchgit, emacs, xmlRpc }:

stdenv.mkDerivation rec {
  name = "org2blog-0.5";

  src = fetchgit {
    url = https://github.com/punchagan/org2blog.git;
    rev = "338abe30e9bc89684f8384f8deaf826b63844da6";
    sha256 = "46ab31e90d0d54071c126b7d5599a3e82062baa79ddf26b988bcb88d306d6827";
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
    description = "A tool to publish directly from Emacs’ org-mode to WordPress blogs.";
    homepage = https://github.com/punchagan/org2blog;
    license = "GPLv3+";

    platforms = stdenv.lib.platforms.all;
  };
}
