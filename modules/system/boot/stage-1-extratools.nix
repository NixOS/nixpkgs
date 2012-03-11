{ config, pkgs, ...}:

with pkgs.lib;

let
  staticBusybox = pkgs.busybox.override {
    enableStatic = true;
  };
in
{

  ###### interface

  options = {
    boot.initrd.withExtraTools = mkOption {
      default = false;
      type = with types; bool;
      description = ''
        Have busybox utils in initrd, and an interactive bash.
      '';
    };
  };

  config = {
    boot.initrd.extraUtilsCommands = mkIf config.boot.initrd.withExtraTools ''
      cp -pv ${pkgs.ncurses}/lib/libncurses*.so.* $out/lib
      cp -pv ${pkgs.readline}/lib/libreadline.so.* $out/lib
      cp -pv ${pkgs.readline}/lib/libhistory.so.* $out/lib
      rm $out/bin/bash
      cp -pv ${pkgs.bashInteractive}/bin/bash $out/bin

      cp -pv ${staticBusybox}/bin/busybox $out/bin
      shopt -s nullglob
      for d in bin sbin; do
        pushd ${staticBusybox}/$d
        # busybox has these, but we'll put them later
        GLOBIGNORE=.:..:mke2fs:ip:modprobe
        for a in *; do
          if [ ! -e $out/bin/$a ]; then
            ln -sf busybox $out/bin/$a
          fi
        done
        popd
      done
      shopt -u nullglob
      unset GLOBIGNORE
    '';

    boot.initrd.extraUtilsCommandsTest = mkIf config.boot.initrd.withExtraTools ''
      $out/bin/busybox
    '';
  };

}
