{ fetchurl, stdenv, emacs, cedet, jdee, texinfo }:

stdenv.mkDerivation rec {
  name = "ecb-2.40";

  src = fetchurl {
    url = "mirror://sourceforge/ecb/${name}.tar.gz";
    sha256 = "0gp56ixfgnyk2j1fps4mk1yv1vpz81kivb3gq9f56jw4kdlhjrjs";
  };

  buildInputs = [ emacs ];
  propagatedBuildInputs = [ cedet jdee ];
  propagatedUserEnvPkgs = propagatedBuildInputs;

  patchPhase = ''
    sed -i "Makefile" \
        -e 's|CEDET[[:blank:]]*=.*$|CEDET = ${cedet}/share/emacs/site-lisp|g ;
            s|INSTALLINFO[[:blank:]]*=.*$|INSTALLINFO = ${texinfo}/bin/install-info|g ;
            s|MAKEINFO[[:blank:]]*=.*$|MAKEINFO = ${texinfo}/bin/makeinfo|g ;
            s|common/cedet.el|cedet.el|g'
  '';

  installPhase = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp -rv *.el *.elc ecb-images "$out/share/emacs/site-lisp"

    mkdir -p "$out/share/info"
    cp -v info-help/*.info* "$out/share/info"
  '';

  meta = {
    description = "ECB, the Emacs Code browser";

    longDescription = ''
      ECB stands for "Emacs Code Browser".  While Emacs already has
      good editing support for many modes, its browsing support is
      somewhat lacking.  That's where ECB comes in: it displays a
      number of informational windows that allow for easy source code
      navigation and overview.
    '';

    license = "GPLv2+";

    homepage = http://ecb.sourceforge.net/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
