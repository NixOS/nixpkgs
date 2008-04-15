{ stdenv, subversion, git, perlLibs }:

if (!subversion.perlBindings)
  then throw "svn perl bindings required to install gitsvnwrapper"
else stdenv.mkDerivation {
  inherit perlLibs;
  name = "git-svn-wrapper";
  phases = "buildPhase";
  buildPhase = "
    gitperllib=${git}/lib/site_perl
    for i in \$perlLibs; do
      gitperllib=\$gitperllib:\$i/lib/site_perl
    done

    ensureDir \$out/bin
    for a in ${git}/bin/git-svn; do
      target=\$out/bin/\$(basename $a)
      target=\$out/bin/\$(basename $a)
      echo \"#!/bin/sh
        export GITPERLLIB=\$gitperllib
        PATH=\\\$PATH:${subversion}/bin
        $a \\\"\\\$@\\\"
      \" > \$target
      chmod +x \$target
    done
  ";

  meta = { 
    description = "git-svn, a bidirectional Git/Subversion gateway";
    license = "GPLv2";
    homepage = http://git.or.cz/;
  };
}
