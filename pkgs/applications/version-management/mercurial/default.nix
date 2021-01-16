{ lib, stdenv, fetchurl, python3Packages, makeWrapper, unzip
, guiSupport ? false, tk ? null
, ApplicationServices
}:

let
  inherit (python3Packages) docutils python;

in python3Packages.buildPythonApplication rec {
  pname = "mercurial";
  version = "5.6";

  src = fetchurl {
    url = "https://mercurial-scm.org/release/mercurial-${version}.tar.gz";
    sha256 = "1hk2y30zzdnlv8f71kabvh0xi9c7qhp28ksh20vpd0r712sv79yz";
  };

  format = "other";

  passthru = { inherit python; }; # pass it so that the same version can be used in hg2git

  buildInputs = [ makeWrapper docutils unzip ]
    ++ lib.optionals stdenv.isDarwin [ ApplicationServices ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = (lib.optionalString guiSupport ''
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
  '') + ''
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
    inherit version;
    description = "A fast, lightweight SCM system for very large distributed projects";
    homepage = "https://www.mercurial-scm.org";
    downloadPage = "https://www.mercurial-scm.org/release/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.eelco ];
    updateWalker = true;
    platforms = lib.platforms.unix;
  };
}
