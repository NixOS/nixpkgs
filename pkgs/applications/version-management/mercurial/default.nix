{ stdenv, fetchurl, python, makeWrapper, docutils
, guiSupport ? false, tk ? null, ssl }:

stdenv.mkDerivation rec {
  name = "mercurial-1.8.2";

  src = fetchurl {
    url = "http://mercurial.selenic.com/release/${name}.tar.gz";
    sha256 = "0hdhaxn05rc33yxbrpqpqakpp4v4zpcd9b8wmfzkk7cdbmmbw9nk";
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
          --prefix PYTHONPATH : "$(toPythonPath "$out ${ssl}")" \
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
