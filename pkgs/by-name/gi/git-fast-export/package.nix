{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  mercurial,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "fast-export";
  version = "221024";

  src = fetchFromGitHub {
    owner = "frej";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-re8iXM8s+TD35UGKalq2kVn8fx68fsnUC7Yo+/DQ9SM=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    mercurial.python
    mercurial
  ];

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
        --prefix PATH : "${git}/bin":"${mercurial.python}/bin":$libexec \
        --prefix PYTHONPATH : "${mercurial}/${mercurial.python.sitePackages}":$sitepackagesPath
    done
  '';

  doInstallCheck = true;
  # deliberately not adding git or hg into nativeInstallCheckInputs - package should
  # be able to work without them in runtime env
  installCheckPhase = ''
    mkdir repo-hg
    pushd repo-hg
    ${mercurial}/bin/hg init
    echo foo > bar
    ${mercurial}/bin/hg add bar
    ${mercurial}/bin/hg commit --message "baz"
    popd

    mkdir repo-git
    pushd repo-git
    ${git}/bin/git init
    ${git}/bin/git config core.ignoreCase false  # for darwin
    $out/bin/hg-fast-export.sh -r ../repo-hg/ --hg-hash
    for s in "foo" "bar" "baz" ; do
      (${git}/bin/git show | grep $s > /dev/null) && echo $s found
    done
    popd
  '';

  meta = with lib; {
    description = "Import mercurial into git";
    homepage = "https://repo.or.cz/w/fast-export.git";
    license = licenses.gpl2;
    maintainers = [ maintainers.koral ];
    platforms = platforms.unix;
  };
}
