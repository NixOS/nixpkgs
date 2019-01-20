{stdenv, fetchgit, mercurial, makeWrapper, subversion}:

with stdenv.lib;
stdenv.mkDerivation {
  name = "fast-export";

  src = fetchgit {
    url = git://repo.or.cz/fast-export.git;
    rev = "d202200fd9daa75cdb37d4cf067d4ca00e269535";
    sha256 = "0m4llsg9rx4sza1kf39kxsdvhi6y87a18wm5k19c5r2h3vpylwcc";
  };

  buildInputs = [mercurial.python mercurial makeWrapper subversion];

  dontBuild = true; # skip svn for now

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
        --prefix PYTHONPATH : "$(echo ${mercurial}/lib/python*/site-packages):$(echo ${mercurial.python}/lib/python*/site-packages)${stdenv.lib.concatMapStrings (x: ":$(echo ${x}/lib/python*/site-packages)") mercurial.pythonPackages or []}" \
        --prefix PATH : "$(dirname $(type -p python))":$l
    done
  '';

  meta = {
    description = "Import svn, mercurial into git";
    homepage = https://repo.or.cz/w/fast-export.git;
    license = licenses.gpl2;
    maintainers = [ maintainers.koral ];
    platforms = stdenv.lib.platforms.unix;
  };
}
