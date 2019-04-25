{ pkgs, lib, ... }:

{
  config = lib.mkIf (lib.any (lib.meta.platformMatch pkgs.stdenv.hostPlatform) pkgs.kexectools.meta.platforms) {
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
            # Don't load the current system profile if we already have a kernel loaded
            [[ 1 = "$(</sys/kernel/kexec_loaded)" ]] && exit

            p=$(readlink -f /nix/var/nix/profiles/system)
            if ! [ -d $p ]; then exit 1; fi
            exec kexec --load $p/kernel --initrd=$p/initrd --append="$(cat $p/kernel-params) init=$p/init"
          '';
      };
  };
}
