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
      description = ''
        Rules for creation, deletion and cleaning of volatile and temporary files
        automatically. See
        <citerefentry><refentrytitle>tmpfiles.d</refentrytitle><manvolnum>5</manvolnum></citerefentry>
        for the exact format.
      '';
    };

    systemd.tmpfiles.packages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExpression "[ pkgs.lvm2 ]";
      apply = map getLib;
      description = ''
        List of packages containing <command>systemd-tmpfiles</command> rules.

        All files ending in .conf found in
        <filename><replaceable>pkg</replaceable>/lib/tmpfiles.d</filename>
        will be included.
        If this folder does not exist or does not contain any files an error will be returned instead.

        If a <filename>lib</filename> output is available, rules are searched there and only there.
        If there is no <filename>lib</filename> output it will fall back to <filename>out</filename>
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
  };
}
