{ lib, stdenv, fetchurl, python2Packages, makeWrapper
, guiSupport ? false, tk ? null
, ApplicationServices
}:

let
  inherit (python2Packages) docutils hg-git dulwich python;

in python2Packages.buildPythonApplication rec {
  pname = "mercurial";
  version = "4.9.1";

  src = fetchurl {
    url = "https://mercurial-scm.org/release/mercurial-${version}.tar.gz";
    sha256 = "0iybbkd9add066729zg01kwz5hhc1s6lhp9rrnsmzq6ihyxj3p8v";
  };

  format = "other";

  inherit python; # pass it so that the same version can be used in hg2git

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ docutils ]
    ++ lib.optionals stdenv.isDarwin [ ApplicationServices ];

  propagatedBuildInputs = [ hg-git dulwich ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = (lib.optionalString guiSupport
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

      # install bash/zsh completions
      install -v -m644 -D contrib/bash_completion $out/share/bash-completion/completions/_hg
      install -v -m644 -D contrib/zsh_completion $out/share/zsh/site-functions/_hg
    '';

  meta = {
    description = "A fast, lightweight SCM system for very large distributed projects";
    homepage = "https://www.mercurial-scm.org";
    downloadPage = "https://www.mercurial-scm.org/release/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.eraserhd ];
    updateWalker = true;
    platforms = lib.platforms.unix;
  };
}
