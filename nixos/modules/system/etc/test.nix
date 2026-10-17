{
  lib,
  coreutils,
  fakechroot,
  fakeroot,
  inotify-tools,
  evalMinimalConfig,
  pkgsModule,
  runCommand,
  util-linux,
  vmTools,
  writeText,
}:
let
  node = evalMinimalConfig (
    { config, ... }:
    {
      imports = [
        pkgsModule
        ../etc/etc.nix
      ];
      environment.etc."passwd" = {
        text = passwdText;
      };
      environment.etc."hosts" = {
        text = hostsText;
        mode = "0751";
      };
      environment.etc."dirlink".source = dirlinkTarget;
    }
  );
  passwdText = ''
    root:x:0:0:System administrator:/root:/run/current-system/sw/bin/bash
  '';
  hostsText = ''
    127.0.0.1 localhost
    ::1 localhost
    # testing...
  '';
  dirlinkTarget = runCommand "dirlink-target" { } "mkdir $out";
in
lib.recurseIntoAttrs {
  test-etc-vm = vmTools.runInLinuxVM (
    runCommand "test-etc-vm" { } ''
      mkdir -p /etc
      ${node.config.system.build.etcActivationCommands}
      set -x
      [[ -L /etc/passwd ]]
      diff /etc/passwd ${writeText "expected-passwd" passwdText}
      [[ 751 = $(stat --format %a /etc/hosts) ]]
      diff /etc/hosts ${writeText "expected-hosts" hostsText}
      [[ -L /etc/dirlink && -d /etc/dirlink ]]
      # A second activation must replace the symlink to a directory atomically, never remove it.
      ${inotify-tools}/bin/inotifywait --monitor --event delete --format %f --outfile deleted /etc 2> inotify.log &
      until grep -q "Watches established" inotify.log; do sleep 0.1; done
      ${node.config.system.build.etcActivationCommands}
      kill $!
      if grep -qx dirlink deleted; then
        echo "/etc/dirlink was removed during activation"
        exit 1
      fi
      set +x
      touch $out
    ''
  );

  # fakeroot is behaving weird
  test-etc-fakeroot =
    runCommand "test-etc"
      {
        nativeBuildInputs = [
          fakeroot
          fakechroot
          # for chroot
          coreutils
          # fakechroot needs getopt, which is provided by util-linux
          util-linux
        ];
        fakeRootCommands = ''
          mkdir -p /etc
          ${node.config.system.build.etcActivationCommands}
          diff /etc/hosts ${writeText "expected-hosts" hostsText}
          touch $out
        '';
      }
      ''
        mkdir fake-root
        export FAKECHROOT_EXCLUDE_PATH=/dev:/proc:/sys:${builtins.storeDir}:$out
        if [ -e "$NIX_ATTRS_SH_FILE" ]; then
          export FAKECHROOT_EXCLUDE_PATH=$FAKECHROOT_EXCLUDE_PATH:$NIX_ATTRS_SH_FILE
        fi
        fakechroot fakeroot chroot $PWD/fake-root bash -e -c '
          if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; fi
          source $stdenv/setup
          eval "$fakeRootCommands"
        '
      '';

}
