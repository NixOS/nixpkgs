source $stdenv/setup

substitute $dllFixer $out --subst-var-by perl $perl/bin/perl
chmod +x $out
