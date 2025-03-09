{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  mercurial,
  makeWrapper,
  nix-update-script,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fast-export";
  version = "231118";

  src = fetchFromGitHub {
    owner = "frej";
    repo = "fast-export";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JUy0t2yzd4bI7WPGG1E8L1topLfR5leV/WTU+u0bCyM=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/frej/fast-export/commit/a3d0562737e1e711659e03264e45cb47a5a2f46d.patch?full_index=1";
      hash = "sha256-vZOHnb5lXO22ElCK4oWQKCcPIqRyZV5axWfZqa84V1Y=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    mercurial.python
    mercurial
  ];

  installPhase = ''
    binPath=$out/bin
    libexecPath=$out/libexec/fast-export
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Import mercurial into git";
    homepage = "https://repo.or.cz/w/fast-export.git";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.koral ];
    platforms = lib.platforms.unix;
  };
})
