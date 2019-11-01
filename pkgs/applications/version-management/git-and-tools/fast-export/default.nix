{stdenv, fetchgit, mercurial, makeWrapper}:

stdenv.mkDerivation rec {
  pname = "fast-export";
  version = "190107";

  src = fetchgit {
    url = git://repo.or.cz/fast-export.git;
    rev = "v${version}";
    sha256 = "14azfps9jd5anivcvfwflgsvqdyy6gm9jy284kzx2ng9f7871d14";
  };

  buildInputs = [mercurial.python mercurial makeWrapper];

  installPhase = ''
    binPath=$out/bin
    libexecPath=$out/libexec/${pname}
    sitepackagesPath=$out/${mercurial.python.sitePackages}
    mkdir -p $binPath $libexecPath $sitepackagesPath

    # Patch shell scripts so they can execute the Python scripts
    sed -i "s|ROOT=.*|ROOT=$libexecPath|" *.sh

    mv hg-fast-export.sh hg-reset.sh $binPath
    mv hg-fast-export.py hg-reset.py $libexecPath
    mv hg2git.py pluginloader plugins $sitepackagesPath

    for script in $out/bin/*.sh; do
      wrapProgram $script \
        --prefix PATH : "${mercurial.python}/bin":$libexec \
        --prefix PYTHONPATH : "${mercurial}/${mercurial.python.sitePackages}":$sitepackagesPath
    done
  '';

  meta = with stdenv.lib; {
    description = "Import mercurial into git";
    homepage = https://repo.or.cz/w/fast-export.git;
    license = licenses.gpl2;
    maintainers = [ maintainers.koral ];
    platforms = platforms.unix;
  };
}
