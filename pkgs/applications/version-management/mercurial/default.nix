args: with args;

stdenv.mkDerivation rec {
  name = "mercurial-1.4.3";
  src = fetchurl {
    url = "http://www.selenic.com/mercurial/release/${name}.tar.gz";
    sha256 = "091agbxlhansf66ams7n1spwgr3frra0y33dipcqbhx3mjx21j4w";
  };

  inherit python; # pass it so that the same version can be used in hg2git

  buildInputs = [ python makeWrapper ];
  makeFlags = "PREFIX=$(out)";
  postInstall = (if args.guiSupport then
    ''
      ensureDir $out/etc/mercurial
      cp contrib/hgk $out/bin
      cat >> $out/etc/mercurial/hgrc << EOF
      [extensions]
      hgk=$out/lib/${python.libPrefix}/site-packages/hgext/hgk.py
      EOF
      # setting HG so that hgk can be run itself as well (not only hg view)
      WRAP_TK=" --set TK_LIBRARY \"${tk}/lib/tk8.4\"
                --set HG \"$out/bin/hg\"
                --prefix PATH : \"${tk}/bin\" "
    ''
    else "")
    +
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
