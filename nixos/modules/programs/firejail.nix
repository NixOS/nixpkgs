{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.firejail;

  wrappedBins = pkgs.runCommand "firejail-wrapped-binaries"
    { preferLocalBuild = true;
      allowSubstitutes = false;
    }
    ''
      mkdir -p $out/bin
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (command: value:
      let
        opts = if builtins.isAttrs value
        then value
        else { executable = value; profile = null; extraArgs = []; };
        args = lib.escapeShellArgs (
          opts.extraArgs
          ++ (optional (opts.profile != null) "--profile=${toString opts.profile}")
          );
      in
      ''
        cat <<_EOF >$out/bin/${command}
        #! ${pkgs.runtimeShell} -e
        exec /run/wrappers/bin/firejail ${args} -- ${toString opts.executable} "\$@"
        _EOF
        chmod 0755 $out/bin/${command}
      '') cfg.wrappedBinaries)}
    '';

in {
  options.programs.firejail = {
    enable = mkEnableOption (lib.mdDoc "firejail");

    wrappedBinaries = mkOption {
      type = types.attrsOf (types.either types.path (types.submodule {
        options = {
          executable = mkOption {
            type = types.path;
            description = "Executable to run sandboxed";
            example = literalExpression ''"''${lib.getBin pkgs.firefox}/bin/firefox"'';
          };
          profile = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = "Profile to use";
            example = literalExpression ''"''${pkgs.firejail}/etc/firejail/firefox.profile"'';
          };
          extraArgs = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "Extra arguments to pass to firejail";
            example = [ "--private=~/.firejail_home" ];
          };
        };
      }));
      default = {};
      example = literalExpression ''
        {
          firefox = {
            executable = "''${lib.getBin pkgs.firefox}/bin/firefox";
            profile = "''${pkgs.firejail}/etc/firejail/firefox.profile";
          };
          mpv = {
            executable = "''${lib.getBin pkgs.mpv}/bin/mpv";
            profile = "''${pkgs.firejail}/etc/firejail/mpv.profile";
          };
        }
      '';
      description = lib.mdDoc ''
        Wrap the binaries in firejail and place them in the global path.

        You will get file collisions if you put the actual application binary in
        the global environment (such as by adding the application package to
        `environment.systemPackages`), and applications started via
        .desktop files are not wrapped if they specify the absolute path to the
        binary.
      '';
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.firejail =
      { setuid = true;
        owner = "root";
        group = "root";
        source = "${lib.getBin pkgs.firejail}/bin/firejail";
      };

    environment.systemPackages = [ pkgs.firejail ] ++ [ wrappedBins ];
  };

  meta.maintainers = with maintainers; [ peterhoeg ];
}
