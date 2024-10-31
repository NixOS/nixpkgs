{
  config,
  lib,
  pkgs,
  ...
}:

let
  perlWrapped = pkgs.perl.withPackages (
    p: with p; [
      ConfigIniFiles
      FileSlurp
    ]
  );
in
{
  options.system.switch = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to include the capability to switch configurations.

        Disabling this makes the system unable to be reconfigured via `nixos-rebuild`.

        This is good for image based appliances where updates are handled
        outside the image. Reducing features makes the image lighter and
        slightly more secure.
      '';
    };

    enableNg = lib.mkOption {
      type = lib.types.bool;
      default = config.system.switch.enable;
      defaultText = lib.literalExpression "config.system.switch.enable";
      description = ''
        Whether to use `switch-to-configuration-ng`, the Rust-based
        re-implementation of the original Perl `switch-to-configuration`.
      '';
    };
  };

  options.system.apply.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.system.switch.enable;
    internal = true;
    description = ''
      Whether to include the `bin/apply` script.

      Disabling puts `nixos-rebuild` in a legacy mode that won't be maintained
      and removes cheap and useful functionality. It's also slower over ssh.
      This should only be used for testing the `nixos-rebuild` command, to
      pretend that the configuration is an old NixOS.
    '';
  };

  config = lib.mkMerge [
    (lib.mkIf config.system.apply.enable {
      system.activatableSystemBuilderCommands = ''
        mkdir -p $out/bin
        substitute ${./apply/apply.sh} $out/bin/apply \
          --subst-var-by bash ${lib.getExe pkgs.bash} \
          --subst-var-by toplevel ''${!toplevelVar}
        chmod +x $out/bin/apply
      '';
    })
    (lib.mkIf (config.system.switch.enable && !config.system.switch.enableNg) {
      warnings = [
        ''
          The Perl implementation of switch-to-configuration will be deprecated
          and removed in the 25.05 release of NixOS. Please migrate to the
          newer implementation by removing `system.switch.enableNg = false`
          from your configuration. If you are unable to migrate due to any
          issues with the new implementation, please create an issue and tag
          the maintainers of `switch-to-configuration-ng`.
        ''
      ];

      system.activatableSystemBuilderCommands = ''
        mkdir -p $out/bin
        substitute ${./switch-to-configuration.pl} $out/bin/switch-to-configuration \
          --subst-var out \
          --subst-var-by toplevel ''${!toplevelVar} \
          --subst-var-by coreutils "${pkgs.coreutils}" \
          --subst-var-by distroId ${lib.escapeShellArg config.system.nixos.distroId} \
          --subst-var-by installBootLoader ${lib.escapeShellArg config.system.build.installBootLoader} \
          --subst-var-by localeArchive "${config.i18n.glibcLocales}/lib/locale/locale-archive" \
          --subst-var-by perl "${perlWrapped}" \
          --subst-var-by shell "${pkgs.bash}/bin/sh" \
          --subst-var-by su "${pkgs.shadow.su}/bin/su" \
          --subst-var-by systemd "${config.systemd.package}" \
          --subst-var-by utillinux "${pkgs.util-linux}" \
          ;

        chmod +x $out/bin/switch-to-configuration
        ${lib.optionalString (pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform) ''
          if ! output=$(${perlWrapped}/bin/perl -c $out/bin/switch-to-configuration 2>&1); then
            echo "switch-to-configuration syntax is not valid:"
            echo "$output"
            exit 1
          fi
        ''}
      '';
    })
    (lib.mkIf config.system.switch.enableNg {
      # Use a subshell so we can source makeWrapper's setup hook without
      # affecting the rest of activatableSystemBuilderCommands.
      system.activatableSystemBuilderCommands = ''
        (
          source ${pkgs.buildPackages.makeWrapper}/nix-support/setup-hook

          mkdir -p $out/bin
          ln -sf ${lib.getExe pkgs.switch-to-configuration-ng} $out/bin/switch-to-configuration
          wrapProgram $out/bin/switch-to-configuration \
            --set OUT $out \
            --set TOPLEVEL ''${!toplevelVar} \
            --set DISTRO_ID ${lib.escapeShellArg config.system.nixos.distroId} \
            --set INSTALL_BOOTLOADER ${lib.escapeShellArg config.system.build.installBootLoader} \
            --set LOCALE_ARCHIVE ${config.i18n.glibcLocales}/lib/locale/locale-archive \
            --set SYSTEMD ${config.systemd.package}
        )
      '';
    })
  ];

}
