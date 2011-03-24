{ stdenv, fetchurl, python, makeWrapper, docutils
, guiSupport ? false, tk ? null }:

stdenv.mkDerivation rec {
  name = "mercurial-1.7.5";

  src = fetchurl {
    url = "http://www.selenic.com/mercurial/release/${name}.tar.gz";
    sha256 = "14849n52vladjmzp0s3nc8q31rkjxswg7l2f2v3j7a9h7n4czbfz";
  };

  inherit python; # pass it so that the same version can be used in hg2git

  buildInputs = [ python makeWrapper docutils ];

  makeFlags = "PREFIX=$(out)";

  postInstall = (stdenv.lib.optionalString guiSupport
    ''
      ensureDir $out/etc/mercurial
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
          --prefix PYTHONPATH : "$(toPythonPath $out)" \
          $WRAP_TK
      done

      # copy hgweb.cgi to allow use in apache
      ensureDir $out/share/cgi-bin
      cp -v hgweb.cgi $out/share/cgi-bin
      chmod u+x $out/share/cgi-bin/hgweb.cgi
    '';

  meta = {
    description = "A fast, lightweight SCM system for very large distributed projects";
    homepage = http://www.selenic.com/mercurial/;
    license = "GPLv2";
  };
}
