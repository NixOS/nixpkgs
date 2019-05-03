{ substituteAll, bash, coreutils, gnused, gnugrep }:

substituteAll {
  src = ./extlinux-conf-builder.sh;
  isExecutable = true;
  path = [coreutils gnused gnugrep];
  inherit bash;
}
