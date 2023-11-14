{ options, config, lib, pkgs, ... }:

let
  inherit (lib)
    mkOption
    types
    ;

  systemBuilderArgs = {
    activationScript = config.system.activationScripts.script;
    dryActivationScript = config.system.dryActivationScript;
  };

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
    system.activatableSystemBuilderCommands = options.system.systemBuilderCommands // {
      description = lib.mdDoc ''
        Like `system.systemBuilderCommands`, but only for the commands that are
        needed *both* when the system is activatable and when it isn't.

        Disclaimer: This option might go away in the future. It might be
        superseded by separating switch-to-configuration into a separate script
        which will make this option superfluous. See
        https://github.com/NixOS/nixpkgs/pull/263462#discussion_r1373104845 for
        a discussion.
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
    system.activatableSystemBuilderCommands = ''
      echo "$activationScript" > $out/activate
      echo "$dryActivationScript" > $out/dry-activate
      substituteInPlace $out/activate --subst-var-by out ''${!toplevelVar}
      substituteInPlace $out/dry-activate --subst-var-by out ''${!toplevelVar}
      chmod u+x $out/activate $out/dry-activate
      unset activationScript dryActivationScript
    '';

    system.systemBuilderCommands = lib.mkIf
      config.system.activatable
      config.system.activatableSystemBuilderCommands;
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
          ${config.system.activatableSystemBuilderCommands}
        '';
  };
}
