{ fetchurl, stdenv, emacs }:

stdenv.mkDerivation rec {
  name = "cedet-1.0pre4";

  src = fetchurl {
    url = "mirror://sourceforge/cedet/${name}.tar.gz";
    sha256 = "0r1cvik8drbx4if3a54xla7l31gcqwb44rqqgfqdvwg5wzcd5slv";
  };

  buildInputs = [ emacs ];

  # FIXME: EIEIO tests fail with:
  # eieio-tests.el:474:1:Error: Symbol's value as variable is void: class-typep-var
  # See http://thread.gmane.org/gmane.emacs.eieio/72 .
  doCheck = false;
  checkPhase = ''
    for dir in *
    do
      if [ -f "$dir/Makefile" ] && grep -q "test:" "$dir/Makefile"
      then
        echo "testing \`$dir'..."
        make test -C "$dir"
      fi
    done
  '';

  installPhase = ''
    ensureDir "$out/share/emacs/site-lisp"
    cp -v */*.el */*.elc "$out/share/emacs/site-lisp"
    chmod a-x "$out/share/emacs/site-lisp/"*

    ensureDir "$out/share/info"
    cp -v */*.info* */*/*.info* "$out/share/info"
  '';

  meta = {
    description = "CEDET, a Collection of Emacs Development Environment Tools";

    longDescription = ''
      CEDET is a collection of tools written with the end goal of
      creating an advanced development environment in Emacs.

      Emacs already is a great environment for writing software, but
      there are additional areas that need improvement.  Many new
      ideas for integrated environments have been developed in newer
      products, such as JBuilder, Eclipse, or KDevelop.  CEDET is a
      project which brings together several different tools needed to
      implement advanced features.

      CEDET includes EIEIO (Enhanced Implementation of Emacs
      Interpreted Objects), Semantic, SRecode, Speedbar, EDE (Emacs
      Development Environment), and COGRE (COnnected GRaph Editor).
    '';

    license = "GPLv2+";

    homepage = http://cedet.sourceforge.net/;
  };
}
