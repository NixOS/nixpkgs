{ lib, substituteAll, coreutils, gnused, bash }:

substituteAll {
  src = ./extlinux-conf-builder.sh;
  isExecutable = true;
  path = lib.makeBinPath [ coreutils gnused ];
  inherit bash;
}
