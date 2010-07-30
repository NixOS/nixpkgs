{ stdenv, fetchurl, python, makeWrapper
, guiSupport ? false, tk ? null }:

stdenv.mkDerivation rec {
  name = "mercurial-1.5.1";
  
  src = fetchurl {
    url = "http://www.selenic.com/mercurial/release/${name}.tar.gz";
    sha256 = "5796dd27c884c0effb027c71925fe2c2506b08e0ac8c5f53db259d378ef96569";
  };

  inherit python; # pass it so that the same version can be used in hg2git

  buildInputs = [ python makeWrapper ];
  
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
    '';

  meta = {
    description = "A fast, lightweight SCM system for very large distributed projects";
    homepage = http://www.selenic.com/mercurial/;
    license = "GPLv2";
  };
}
