{ config, lib, pkgs, ... }:

let

  perlWrapped = pkgs.perl.withPackages (p: with p; [ ConfigIniFiles FileSlurp ]);

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

  config = lib.mkMerge [
    (lib.mkIf (config.system.switch.enable && !config.system.switch.enableNg) {
      system.activatableSystemBuilderCommands = ''
        mkdir $out/bin
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

          mkdir $out/bin
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
