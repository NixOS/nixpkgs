{ fetchgit, stdenv, emacs }:

# TODO: byte-compile in build phase - a buildEmacsPackage that does
# that would be nice

stdenv.mkDerivation rec {
  name = "calfw-1.3";

  src = fetchgit {
    url = "git://github.com/kiwanami/emacs-calfw.git";
    rev = "e3408d8d1f4dd6d1e76883d728efc62bba41ee7a";
    sha256 = "1b9c74200aa0b06fcd199f6c2cc91fdfaceb04e7744fe842e1fe4839c0c933f3";
  };

  buildInputs = [ emacs ];

  installPhase =
    ''
       ensureDir "$out/share/doc/${name}"
       cp -v readme.md "$out/share/doc/${name}"

       ensureDir "$out/share/emacs/site-lisp/"
       cp *.el "$out/share/emacs/site-lisp/"
    '';

  meta = {
    description = "A calendar framework for Emacs";

    license = "GPLv3+";

    maintainers = with stdenv.lib.maintainers; [ chaoflow ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
