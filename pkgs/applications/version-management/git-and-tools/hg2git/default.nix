args: with args;
stdenv.mkDerivation {
  name = "hg2git";

  src = sourceByName "hg2git";

  buildInputs =([mercurial.python mercurial makeWrapper]);

  installPhase = ''
    ensureDir $out/bin;
    cp hg2git.sh hg2git.py $out/bin
    cat >> $out/bin/hg2git-doc << EOF
    #!${coreutils}/bin/cat
    $(cat hg2git.txt)
    EOF
    chmod +x $out/bin/hg2git-doc
    wrapProgram $out/bin/hg2git.sh \
      --set PYTHONPATH "$(echo ${mercurial}/lib/python*/site-packages)"
  '';

  meta = {
      description = "mercurial to git one way conversion";
      homepage = "http://git.grml.org/?p=hg-to-git.git;a=summary";
      license = "?"; # the .py file is GPLv2
  };
}
