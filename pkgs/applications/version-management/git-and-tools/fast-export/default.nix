{stdenv, fetchgit, mercurial, coreutils, git, makeWrapper, subversion}:

with stdenv.lib;
stdenv.mkDerivation {
  name = "fast-export";

  src = fetchgit {
    url = git://repo.or.cz/fast-export.git;
    rev = "d202200fd9daa75cdb37d4cf067d4ca00e269535";
    sha256 = "1ci0jbprs7hqqzq4mqi5b9vlc43lmk2bn2kjx49bdjkqajvlicd7";
  };

  buildInputs = [mercurial.python mercurial makeWrapper subversion];

  buildPhase="true"; # skip svn for now

  # TODO also support svn stuff
  # moving .py files into lib directory so that you can't pick the wrong file from PATH.
  # This requires redefining ROOT
  installPhase = ''
    sed -i "s@/usr/bin/env.*@$(type -p python)@" *.py
    l=$out/libexec/git-fast-export
    mkdir -p $out/{bin,doc/git-fast-export} $l
    sed -i "s@ROOT=.*@ROOT=$l@" *.sh
    mv *.sh $out/bin
    mv *.py $l
    for p in $out/bin/*.sh; do
      wrapProgram $p \
        --prefix PYTHONPATH : "$(echo ${mercurial}/lib/python*/site-packages):$(echo ${mercurial.python}/lib/python*/site-packages)${stdenv.lib.concatMapStrings (x: ":$(echo ${x}/lib/python*/site-packages)") mercurial.pythonPackages}" \
        --prefix PATH : "$(dirname $(type -p python))":$l
    done
  '';

  meta = {
    description = "Import svn, mercurial into git";
    homepage = http://repo.or.cz/w/fast-export.git;
    license = licenses.gpl2;
    maintainers = [ maintainers.koral ];
  };
}
