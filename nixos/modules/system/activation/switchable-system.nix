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

  description = extra: ''
    Whether to include the capability to switch configurations.

    Disabling this makes the system unable to be reconfigured via `nixos-rebuild`.

    ${extra}
  '';

in

{

  options.system.switch = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = description ''
        This is good for image based appliances where updates are handled
        outside the image. Reducing features makes the image lighter and
        slightly more secure.
      '';
    };

    enableNg = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = description ''
        Whether to use `switch-to-configuration-ng`, an experimental
        re-implementation of `switch-to-configuration` with the goal of
        replacing the original.
      '';
    };
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = with config.system.switch; enable -> !enableNg;
          message = "Only one of system.switch.enable and system.switch.enableNg may be enabled at a time";
        }
      ];
    }
    (lib.mkIf config.system.switch.enable {
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
