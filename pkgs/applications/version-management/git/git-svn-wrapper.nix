args: with args;
if (!args.subversion.perlBindings) then abort "svn perl bindings required to install gitsvnwrapper"
else args.stdenv.mkDerivation {
  inherit git perlLibs subversion;
  name = "git-svn-wrapper";
  phases = "buildPhase";
  buildPhase = "
    gitperllib=\$git/lib/site_perl
    for i in \$perlLibs; do
      gitperllib=\$gitperllib:\$i/lib/site_perl
    done

    ensureDir \$out/bin
    for a in \$git/bin/*; do
      target=\$out/bin/\$(basename $a)
      target=\$out/bin/\$(basename $a)
      echo \"#!/bin/sh
        export GITPERLLIB=\$gitperllib
        PATH=\\\$PATH:$subversion/bin
        $a \\\"\\\$@\\\"
      \" > \$target
      chmod +x \$target
    done
  ";

  meta = { 
      description = "simple wrapper around git adding env variables so that git-svn works without extra work";
  };
}
