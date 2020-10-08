{ config, lib, pkgs, ... }:

with lib;

let cfg = config.system.autoUpgrade;

in {

  options = {

    system.autoUpgrade = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to periodically upgrade NixOS to the latest
          version. If enabled, a systemd timer will run
          <literal>nixos-rebuild switch --upgrade</literal> once a
          day.
        '';
      };

      flake = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "github:kloenk/nix";
        description = ''
          The Flake URI of the NixOS configuration to build.
          Disables the option <option>system.autoUpgrade.channel</option>.
        '';
      };

      channel = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "https://nixos.org/channels/nixos-14.12-small";
        description = ''
          The URI of the NixOS channel to use for automatic
          upgrades. By default, this is the channel set using
          <command>nix-channel</command> (run <literal>nix-channel
          --list</literal> to see the current value).
        '';
      };

      flags = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [
          "-I"
          "stuff=/home/alice/nixos-stuff"
          "--option"
          "extra-binary-caches"
          "http://my-cache.example.org/"
        ];
        description = ''
          Any additional flags passed to <command>nixos-rebuild</command>.

          If you are using flakes and use a local repo you can add
          <command>[ "--update-input" "nixpkgs" "--commit-lock-file" ]</command>
          to update nixpkgs.
        '';
      };

      dates = mkOption {
        default = "04:40";
        type = types.str;
        description = ''
          Specification (in the format described by
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>) of the time at
          which the update will occur.
        '';
      };

      allowReboot = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Reboot the system into the new generation instead of a switch
          if the new generation uses a different kernel, kernel modules
          or initrd than the booted system.
        '';
      };

      randomizedDelaySec = mkOption {
        default = "0";
        type = types.str;
        example = "45min";
        description = ''
          Add a randomized delay before each automatic upgrade.
          The delay will be chozen between zero and this value.
          This value must be a time span in the format specified by
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable {

    assertions = [{
      assertion = !((cfg.channel != null) && (cfg.flake != null));
      message = ''
        The options 'system.autoUpgrade.channels' and 'system.autoUpgrade.flake' cannot both be set.
      '';
    }];

    system.autoUpgrade.flags = [ "--no-build-output" ]
      ++ (if cfg.flake == null then
        (if cfg.channel == null then
          [ "--upgrade" ]
        else [
          "-I"
          "nixpkgs=${cfg.channel}/nixexprs.tar.xz"
        ])
      else
        [ "--flake ${cfg.flake}" ]);

    systemd.services.nixos-upgrade = {
      description = "NixOS Upgrade";

      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;

      serviceConfig.Type = "oneshot";

      environment = config.nix.envVars // {
        inherit (config.environment.sessionVariables) NIX_PATH;
        HOME = "/root";
      } // config.networking.proxy.envVars;

      path = with pkgs; [
        coreutils
        gnutar
        xz.bin
        gzip
        gitMinimal
        config.nix.package.out
      ];

      script = let
        nixos-rebuild =
          "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
      in if cfg.allowReboot then ''
        ${nixos-rebuild} boot ${toString cfg.flags}
        booted="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
        built="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"
        if [ "$booted" = "$built" ]; then
          ${nixos-rebuild} switch ${toString cfg.flags}
        else
          /run/current-system/sw/bin/shutdown -r +1
        fi
      '' else ''
        ${nixos-rebuild} switch ${toString cfg.flags}
      '';

      startAt = cfg.dates;
    };

    systemd.timers.nixos-upgrade.timerConfig.RandomizedDelaySec =
      cfg.randomizedDelaySec;

  };

}
