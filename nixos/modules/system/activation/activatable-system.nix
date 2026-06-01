{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkOption
    types
    ;
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
      description = ''
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
  config =
    let
      activationScript = lib.getExe (
        (pkgs.writeShellApplication {
          name = "activate";
          text = config.system.activationScripts.script;
          checkPhase = "";
          bashOptions = [ ];
        }).overrideAttrs
          { preferLocalBuild = true; }
      );
      dryActivationScript = lib.getExe (
        (pkgs.writeShellApplication {
          name = "dry-activate";
          text = config.system.dryActivationScript;
          checkPhase = "";
          bashOptions = [ ];
        }).overrideAttrs
          { preferLocalBuild = true; }
      );
    in
    {
      system.activatableSystemBuilderCommands =
        # We use sed here instead of substitute(InPlace), because the substitute
        # functions load the content of the file into a bash variable, which fails
        # for very large activation scripts.
        # bash
        ''
          cp ${activationScript} $out/activate
          cp ${dryActivationScript} $out/dry-activate
          ${lib.getExe pkgs.buildPackages.gnused} --in-place --expression "s|@out@|''${!toplevelVar}|g" $out/activate $out/dry-activate
        '';

      system.systemBuilderCommands = lib.mkIf config.system.activatable config.system.activatableSystemBuilderCommands;
      system.systemBuilderArgs = lib.mkIf config.system.activatable {
        toplevelVar = "out";
      };

      system.build.separateActivationScript =
        pkgs.runCommand "separate-activation-script"
          {
            toplevelVar = "toplevel";
            toplevel = config.system.build.toplevel;
          }
          ''
            mkdir $out
            ${config.system.activatableSystemBuilderCommands}
          '';
    };
}
