{ stdenv, fetchurl, python, makeWrapper, docutils, unzip
, guiSupport ? false, tk ? null, curses }:

let
  name = "mercurial-2.2.3";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://mercurial.selenic.com/release/${name}.tar.gz";
    sha256 = "0yv7kn96270fixigry910c1i3zzivimh1xjxywqjn9dshn2y6qbw";
  };

  inherit python; # pass it so that the same version can be used in hg2git
  pythonPackages = [ curses ];

  buildInputs = [ python makeWrapper docutils unzip ];

  makeFlags = "PREFIX=$(out)";

  postInstall = (stdenv.lib.optionalString guiSupport
    ''
      mkdir -p $out/etc/mercurial
      cp contrib/hgk $out/bin
      cat >> $out/etc/mercurial/hgrc << EOF
      [extensions]
      hgk=$out/lib/${python.libPrefix}/site-packages/hgext/hgk.py
      EOF
      # setting HG so that hgk can be run itself as well (not only hg view)
      WRAP_TK=" --set TK_LIBRARY \"${tk}/lib/${tk.libPrefix}\"
                --set HG \"$out/bin/hg\"
                --prefix PATH : \"${tk}/bin\" "
    '') +
    ''
      for i in $(cd $out/bin && ls); do
        wrapProgram $out/bin/$i \
          --prefix PYTHONPATH : "$(toPythonPath "$out ${curses}")" \
          $WRAP_TK
      done

      # copy hgweb.cgi to allow use in apache
      mkdir -p $out/share/cgi-bin
      cp -v hgweb.cgi contrib/hgweb.wsgi $out/share/cgi-bin
      chmod u+x $out/share/cgi-bin/hgweb.cgi
    '';

  meta = {
    description = "A fast, lightweight SCM system for very large distributed projects";
    homepage = "http://www.selenic.com/mercurial/";
    license = "GPLv2";
  };
}
