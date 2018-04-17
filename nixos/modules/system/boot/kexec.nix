{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (pkgs.kexectools.meta.available) {
    environment.systemPackages = [ pkgs.kexectools ];

    systemd.services."prepare-kexec" =
      { description = "Preparation for kexec";
        wantedBy = [ "kexec.target" ];
        before = [ "systemd-kexec.service" ];
        unitConfig.DefaultDependencies = false;
        serviceConfig.Type = "oneshot";
        path = [ pkgs.kexectools ];
        script =
          ''
            p=$(readlink -f /nix/var/nix/profiles/system)
            if ! [ -d $p ]; then exit 1; fi
            exec kexec --load $p/kernel --initrd=$p/initrd --append="$(cat $p/kernel-params) init=$p/init"
          '';
      };
  };
}
