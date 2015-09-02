{ stdenv, fetchurl, python, makeWrapper, docutils, unzip, hg-git, dulwich
, guiSupport ? false, tk ? null, curses
, ApplicationServices }:

let
  version = "3.5";
  name = "mercurial-${version}";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://mercurial.selenic.com/release/${name}.tar.gz";
    sha256 = "19z92dgpxigri195w58xf9b267g4khzgm8wg575y17ykwxw6j3xm";
  };

  inherit python; # pass it so that the same version can be used in hg2git
  pythonPackages = [ curses ];

  buildInputs = [ python makeWrapper docutils unzip ];

  propagatedBuildInputs = stdenv.lib.optional stdenv.isDarwin ApplicationServices;

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
  };
}
