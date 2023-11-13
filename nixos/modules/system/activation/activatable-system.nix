{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkOption
    optionalString
    types
    ;

  perlWrapped = pkgs.perl.withPackages (p: with p; [ ConfigIniFiles FileSlurp ]);

  systemBuilderArgs = {
    activationScript = config.system.activationScripts.script;
    dryActivationScript = config.system.dryActivationScript;
  };

  systemBuilderCommands = ''
    echo "$activationScript" > $out/activate
    echo "$dryActivationScript" > $out/dry-activate
    substituteInPlace $out/activate --subst-var-by out ''${!toplevelVar}
    substituteInPlace $out/dry-activate --subst-var-by out ''${!toplevelVar}
    chmod u+x $out/activate $out/dry-activate
    unset activationScript dryActivationScript

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
    ${optionalString (pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform) ''
      if ! output=$(${perlWrapped}/bin/perl -c $out/bin/switch-to-configuration 2>&1); then
        echo "switch-to-configuration syntax is not valid:"
        echo "$output"
        exit 1
      fi
    ''}
  '';

in
{
  options = {
    system.activatable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to add the activation script to the system profile.

        The default, to have the script available all the time, is what we normally
        do, but for image based systems, this may not be needed or not be desirable.
      '';
    };
    system.build.separateActivationScript = mkOption {
      type = types.package;
      description = ''
        A separate activation script package that's not part of the system profile.

        This is useful for configurations where `system.activatable` is `false`.
        Otherwise, you can just use `system.build.toplevel`.
      '';
    };
  };
  config = {
    system.systemBuilderCommands = lib.mkIf config.system.activatable systemBuilderCommands;
    system.systemBuilderArgs = lib.mkIf config.system.activatable
      (systemBuilderArgs // {
        toplevelVar = "out";
      });

    system.build.separateActivationScript =
      pkgs.runCommand
        "separate-activation-script"
        (systemBuilderArgs // {
          toplevelVar = "toplevel";
          toplevel = config.system.build.toplevel;
        })
        ''
          mkdir $out
          ${systemBuilderCommands}
        '';
  };
}
