{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.boot.kexec;
in
{
  options.boot.kexec = {
    enable = lib.mkEnableOption "kexec" // {
      default = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.kexec-tools;
      defaultText = lib.literalExpression ''lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.kexec-tools'';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kexec-tools ];

    systemd.services.prepare-kexec = {
      description = "Preparation for kexec";
      wantedBy = [ "kexec.target" ];
      before = [ "systemd-kexec.service" ];
      unitConfig.DefaultDependencies = false;
      serviceConfig.Type = "oneshot";
      path = [ pkgs.kexec-tools ];
      script = ''
        # Don't load the current system profile if we already have a kernel loaded
        if [[ 1 = "$(</sys/kernel/kexec_loaded)" ]] ; then
          echo "kexec kernel has already been loaded, prepare-kexec skipped"
          exit 0
        fi

        p=$(readlink -f /nix/var/nix/profiles/system)
        if ! [[ -d $p ]]; then
          echo "Could not find system profile for prepare-kexec"
          exit 1
        fi
        echo "Loading NixOS system via kexec."
        exec kexec --load "$p/kernel" --initrd="$p/initrd" --append="$(cat "$p/kernel-params") init=$p/init"
      '';
    };
  };
}
