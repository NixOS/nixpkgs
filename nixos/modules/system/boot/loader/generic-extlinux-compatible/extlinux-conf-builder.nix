{ lib, pkgs }:

pkgs.replaceVarsWith {
  src = ./extlinux-conf-builder.sh;
  isExecutable = true;
  replacements = {
    path = lib.makeBinPath [
      pkgs.coreutils
      pkgs.gnused
      pkgs.gnugrep
    ];
    inherit (pkgs) bash;
  };
}
