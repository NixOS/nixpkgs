{ stdenv, fetchurl, python2Packages, makeWrapper, unzip
, guiSupport ? false, tk ? null
, ApplicationServices }:

let
  # if you bump version, update pkgs.tortoisehg too or ping maintainer
  version = "4.7";
  name = "mercurial-${version}";
  inherit (python2Packages) docutils hg-git dulwich python;
in python2Packages.buildPythonApplication {
  inherit name;
  format = "other";

  src = fetchurl {
    url = "https://mercurial-scm.org/release/${name}.tar.gz";
    sha256 = "17rl1lyvr3qa5x73xyiwnv09wwiwjd18f01gvispzyvpgx1v3309";
  };

  inherit python; # pass it so that the same version can be used in hg2git

  buildInputs = [ makeWrapper docutils unzip ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ ApplicationServices ];

  propagatedBuildInputs = [ hg-git dulwich ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = (stdenv.lib.optionalString guiSupport
    ''
      mkdir -p $out/etc/mercurial
      cp contrib/hgk $out/bin
      cat >> $out/etc/mercurial/hgrc << EOF
      [extensions]
      hgk=$out/lib/${python.libPrefix}/site-packages/hgext/hgk.py
      EOF
      # setting HG so that hgk can be run itself as well (not only hg view)
      WRAP_TK=" --set TK_LIBRARY ${tk}/lib/${tk.libPrefix}
                --set HG $out/bin/hg
                --prefix PATH : ${tk}/bin "
    '') +
    ''
      for i in $(cd $out/bin && ls); do
        wrapProgram $out/bin/$i \
          $WRAP_TK
      done

      # copy hgweb.cgi to allow use in apache
      mkdir -p $out/share/cgi-bin
      cp -v hgweb.cgi contrib/hgweb.wsgi $out/share/cgi-bin
      chmod u+x $out/share/cgi-bin/hgweb.cgi

      # install bash completion
      install -D -v contrib/bash_completion $out/share/bash-completion/completions/mercurial
    '';

  meta = {
    inherit version;
    description = "A fast, lightweight SCM system for very large distributed projects";
    homepage = https://www.mercurial-scm.org;
    downloadPage = https://www.mercurial-scm.org/release/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    updateWalker = true;
    platforms = stdenv.lib.platforms.unix;
  };
}
