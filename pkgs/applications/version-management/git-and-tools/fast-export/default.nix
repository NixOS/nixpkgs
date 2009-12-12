args: with args;
stdenv.mkDerivation {
  name = "fast-export";

  # REGION AUTO UPDATE:    { name="git_fast_export"; type = "git"; url="git://repo.or.cz/hg2git.git"; }
  src = sourceFromHead "git_fast_export-1464dabbff7fe42b9069e98869db40276d295ad6.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/git_fast_export-1464dabbff7fe42b9069e98869db40276d295ad6.tar.gz"; sha256 = "0808bafddce07c8f3dc2116f2c33e56f5589927630e0b72219e64d8a6c8c0023"; });
  # END

  buildInputs =([mercurial.python mercurial makeWrapper subversion]);

  buildPhase="true"; # skip svn for now

  # TODO also support svn stuff
  # moving .py files into lib directory so that you can't pick the wrong file from PATH.
  # This requires redefining ROOT
  installPhase = ''
    sed -i "s@/usr/bin/env.*@$(type -p python)@" *.py
    l=$out/libexec/git-fast-export
    ensureDir $out/{bin,doc/git-fast-export} $l
    mv *.txt $out/doc/git-fast-export
    sed -i "s@ROOT=.*@ROOT=$l@" *.sh
    mv *.sh $out/bin
    mv *.py $l
    for p in $out/bin/*.sh; do
      wrapProgram $p \
        --set PYTHONPATH "$(echo ${mercurial}/lib/python*/site-packages)" \
        --prefix PATH : "$(dirname $(type -p python))":$l
    done
  '';

  # usage: 
  meta = {
      description = "import svn, mercurial into git";
      homepage = "http://repo.or.cz/w/fast-export.git";
      license = "?"; # the .py file is GPLv2
  };
}
