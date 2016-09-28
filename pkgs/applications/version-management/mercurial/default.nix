{ stdenv, fetchurl, pythonPackages, makeWrapper, docutils, unzip
, guiSupport ? false, tk ? null
, ApplicationServices, cf-private }:

let
  # if you bump version, update pkgs.tortoisehg too or ping maintainer
  version = "3.8.2";
  name = "mercurial-${version}";
  inherit (pythonPackages) curses docutils hg-git dulwich python;
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "https://mercurial-scm.org/release/${name}.tar.gz";
    sha256 = "1zdz42znd6i7c3nf31j0k6frcs68qyniyvcad8k2a1hlarlv2y6b";
  };

  inherit python; # pass it so that the same version can be used in hg2git
  pythonPackages = [ curses ];

  buildInputs = [ python makeWrapper docutils unzip ];

  propagatedBuildInputs = stdenv.lib.optionals stdenv.isDarwin
    [ ApplicationServices cf-private ];

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
          --prefix PYTHONPATH : "$(toPythonPath "$out ${curses}"):$(toPythonPath "$out ${hg-git}"):$(toPythonPath "$out ${dulwich}")" \
          $WRAP_TK
      done

      mkdir -p $out/etc/mercurial
      cat >> $out/etc/mercurial/hgrc << EOF
      [web]
      cacerts = /etc/ssl/certs/ca-certificates.crt
      EOF

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
    homepage = "http://mercurial.selenic.com/";
    downloadPage = "http://mercurial.selenic.com/release/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    updateWalker = true;
    platforms = stdenv.lib.platforms.unix;
  };
}
