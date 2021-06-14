{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.cowsay;

  mkCow = cow: ''
    $the_cow = <<EOC;
      ${builtins.replaceStrings [ "\n" ] [ "\n  " ] cow}
    EOC
  '';

  mkCows = cows:
    let
      mkCowFile = name: cow: {
        "cowsayCow${name}" = {
          target = "cows/${name}.cow";
          text = mkCow cow;
        };
      };
    in mkMerge (attrsets.mapAttrsToList mkCowFile cows);

in {
  options.programs.cowsay = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable cowsay.
        Might conflict with cowsay installed via other means.
      '';
    };

    package = mkOption {
      type = types.path;
      description = ''
        The cowsay package to use.
      '';
      default = pkgs.cowsay;
      example = literalExample "pkgs.cowsay";
    };

    cows = mkOption {
      type = types.attrsOf types.lines;
      default = { };
      description = ''
        Set of cows; Backslashes have to be escaped
      '';
      example = lib.literalExample ''{
        giraffe = \'\'
          $thoughts
           $thoughts
            $thoughts
               ^__^
               (oo)
               (__)
                 \\ \\
                  \\ \\
                   \\ \\
                    \\ \\
                     \\ \\
                      \\ \\
                       \\ \\
                        \\ \\______
                         \\       )\\/\\/\\
                          ||----w |
                          ||     ||
        \'\';
      };'';
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        (writeShellScriptBin "cowsay" ''
          export COWPATH="/etc/cows:${cfg.package}/share/cows"
          exec "${cfg.package}/bin/cowsay" $@
        '')
        (writeShellScriptBin "cowthink" ''
          export COWPATH="/etc/cows:${cfg.package}/share/cows"
          exec "${cfg.package}/bin/cowthink" $@
        '')
        # only installs the man pages
        #TODO: is there a way to fix conflicts that could arise when also using native-package-manager/nix-env/home-manager/nix-shell
        (cowsay.overrideAttrs (oldAttrs: {
          meta = oldAttrs.meta // {
            outputsToInstall = [ "man" ];
          };
        }))
      ];

      etc = mkCows cfg.cows;
    };
  };
}
