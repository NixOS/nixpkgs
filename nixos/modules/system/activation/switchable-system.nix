{ config, lib, pkgs, ... }:

let

  perlWrapped = pkgs.perl.withPackages (p: with p; [ ConfigIniFiles FileSlurp ]);

in

{

  options = {
    system.switch.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to include the capability to switch configurations.

        Disabling this makes the system unable to be reconfigured via `nixos-rebuild`.

        This is good for image based appliances where updates are handled
        outside the image. Reducing features makes the image lighter and
        slightly more secure.
      '';
    };
  };

  config = lib.mkIf config.system.switch.enable {
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
  };

}
