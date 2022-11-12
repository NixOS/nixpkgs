{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.systemd.tmpfiles;
  systemd = config.systemd.package;
in
{
  options = {
    systemd.tmpfiles.rules = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "d /tmp 1777 root root 10d" ];
      description = lib.mdDoc ''
        Rules for creation, deletion and cleaning of volatile and temporary files
        automatically. See
        {manpage}`tmpfiles.d(5)`
        for the exact format.
      '';
    };

    systemd.tmpfiles.packages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExpression "[ pkgs.lvm2 ]";
      apply = map getLib;
      description = lib.mdDoc ''
        List of packages containing {command}`systemd-tmpfiles` rules.

        All files ending in .conf found in
        {file}`«pkg»/lib/tmpfiles.d`
        will be included.
        If this folder does not exist or does not contain any files an error will be returned instead.

        If a {file}`lib` output is available, rules are searched there and only there.
        If there is no {file}`lib` output it will fall back to {file}`out`
        and if that does not exist either, the default output will be used.
      '';
    };
  };

  config = {
    systemd.additionalUpstreamSystemUnits = [
      "systemd-tmpfiles-clean.service"
      "systemd-tmpfiles-clean.timer"
      "systemd-tmpfiles-setup.service"
      "systemd-tmpfiles-setup-dev.service"
    ];

    systemd.additionalUpstreamUserUnits = [
      "systemd-tmpfiles-clean.service"
      "systemd-tmpfiles-clean.timer"
      "systemd-tmpfiles-setup.service"
    ];

    environment.etc = {
      "tmpfiles.d".source = (pkgs.symlinkJoin {
        name = "tmpfiles.d";
        paths = map (p: p + "/lib/tmpfiles.d") cfg.packages;
        postBuild = ''
          for i in $(cat $pathsPath); do
            (test -d "$i" && test $(ls "$i"/*.conf | wc -l) -ge 1) || (
              echo "ERROR: The path '$i' from systemd.tmpfiles.packages contains no *.conf files."
              exit 1
            )
          done
        '' + concatMapStrings (name: optionalString (hasPrefix "tmpfiles.d/" name) ''
          rm -f $out/${removePrefix "tmpfiles.d/" name}
        '') config.system.build.etc.passthru.targets;
      }) + "/*";
    };

    systemd.tmpfiles.packages = [
      # Default tmpfiles rules provided by systemd
      (pkgs.runCommand "systemd-default-tmpfiles" {} ''
        mkdir -p $out/lib/tmpfiles.d
        cd $out/lib/tmpfiles.d

        ln -s "${systemd}/example/tmpfiles.d/home.conf"
        ln -s "${systemd}/example/tmpfiles.d/journal-nocow.conf"
        ln -s "${systemd}/example/tmpfiles.d/portables.conf"
        ln -s "${systemd}/example/tmpfiles.d/static-nodes-permissions.conf"
        ln -s "${systemd}/example/tmpfiles.d/systemd.conf"
        ln -s "${systemd}/example/tmpfiles.d/systemd-nologin.conf"
        ln -s "${systemd}/example/tmpfiles.d/systemd-nspawn.conf"
        ln -s "${systemd}/example/tmpfiles.d/systemd-tmp.conf"
        ln -s "${systemd}/example/tmpfiles.d/tmp.conf"
        ln -s "${systemd}/example/tmpfiles.d/var.conf"
        ln -s "${systemd}/example/tmpfiles.d/x11.conf"
      '')
      # User-specified tmpfiles rules
      (pkgs.writeTextFile {
        name = "nixos-tmpfiles.d";
        destination = "/lib/tmpfiles.d/00-nixos.conf";
        text = ''
          # This file is created automatically and should not be modified.
          # Please change the option ‘systemd.tmpfiles.rules’ instead.

          ${concatStringsSep "\n" cfg.rules}
        '';
      })
    ];

    systemd.tmpfiles.rules = [
      "d  /nix/var                           0755 root root - -"
      "L+ /nix/var/nix/gcroots/booted-system 0755 root root - /run/booted-system"
      "d  /run/lock                          0755 root root - -"
      "d  /var/db                            0755 root root - -"
      "L  /etc/mtab                          -    -    -    - ../proc/mounts"
      "L  /var/lock                          -    -    -    - ../run/lock"
      # Boot-time cleanup
      "R! /etc/group.lock                    -    -    -    - -"
      "R! /etc/passwd.lock                   -    -    -    - -"
      "R! /etc/shadow.lock                   -    -    -    - -"
      "R! /etc/mtab*                         -    -    -    - -"
      "R! /nix/var/nix/gcroots/tmp           -    -    -    - -"
      "R! /nix/var/nix/temproots             -    -    -    - -"
    ];
  };
}
