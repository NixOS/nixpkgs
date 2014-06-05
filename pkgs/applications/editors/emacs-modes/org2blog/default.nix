{ stdenv, fetchgit, emacs, org, xmlRpc, metaweblog }:

stdenv.mkDerivation rec {
  name = "org2blog-0.8.1";

  src = fetchgit {
    url = https://github.com/punchagan/org2blog.git;
    rev = "5f573ff3e4007c16517a5fe28c4f5d8dde3f8a77";
    sha256 = "e83c08ceece92bb507be70046db4a7fa87a4af34ad3f84a727e0bd6a1dd99a33";
  };

  buildInputs = [ emacs ];
  propagatedUserEnvPkgs = [ org xmlRpc metaweblog ];

  buildPhase = ''
    emacs -L . -L ${org}/share/emacs/site-lisp/org \
               -L ${xmlRpc}/share/emacs/site-lisp \
               -L ${metaweblog}/share/emacs/site-lisp \
               --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el* $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Publish directly from Emacs’ org-mode to WordPress blogs";
    homepage = https://github.com/punchagan/org2blog;
    license = "GPLv3+";

    platforms = stdenv.lib.platforms.all;
  };
}
