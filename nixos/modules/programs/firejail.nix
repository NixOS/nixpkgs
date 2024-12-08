{ config, lib, pkgs, ... }:

let
  cfg = config.programs.firejail;

  wrappedBins = pkgs.runCommand "firejail-wrapped-binaries"
    { preferLocalBuild = true;
      allowSubstitutes = false;
      # take precedence over non-firejailed versions
      meta.priority = -1;
    }
    ''
      mkdir -p $out/bin
      mkdir -p $out/share/applications
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (command: value:
      let
        opts = if builtins.isAttrs value
        then value
        else { executable = value; desktop = null; profile = null; extraArgs = []; };
        args = lib.escapeShellArgs (
          opts.extraArgs
          ++ (lib.optional (opts.profile != null) "--profile=${builtins.toString opts.profile}")
        );
      in
      ''
        cat <<_EOF >$out/bin/${command}
        #! ${pkgs.runtimeShell} -e
        exec /run/wrappers/bin/firejail ${args} -- ${builtins.toString opts.executable} "\$@"
        _EOF
        chmod 0755 $out/bin/${command}

        ${lib.optionalString (opts.desktop != null) ''
          substitute ${opts.desktop} $out/share/applications/$(basename ${opts.desktop}) \
            --replace ${opts.executable} $out/bin/${command}
        ''}
      '') cfg.wrappedBinaries)}
    '';

in {
  options.programs.firejail = {
    enable = lib.mkEnableOption "firejail, a sandboxing tool for Linux";

    wrappedBinaries = lib.mkOption {
      type = lib.types.attrsOf (lib.types.either lib.types.path (lib.types.submodule {
        options = {
          executable = lib.mkOption {
            type = lib.types.path;
            description = "Executable to run sandboxed";
            example = lib.literalExpression ''"''${lib.getBin pkgs.firefox}/bin/firefox"'';
          };
          desktop = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = ".desktop file to modify. Only necessary if it uses the absolute path to the executable.";
            example = lib.literalExpression ''"''${pkgs.firefox}/share/applications/firefox.desktop"'';
          };
          profile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Profile to use";
            example = lib.literalExpression ''"''${pkgs.firejail}/etc/firejail/firefox.profile"'';
          };
          extraArgs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Extra arguments to pass to firejail";
            example = [ "--private=~/.firejail_home" ];
          };
        };
      }));
      default = {};
      example = lib.literalExpression ''
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
      description = ''
        Wrap the binaries in firejail and place them in the global path.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.firejail =
      { setuid = true;
        owner = "root";
        group = "root";
        source = "${lib.getBin pkgs.firejail}/bin/firejail";
      };

    environment.systemPackages = [ pkgs.firejail ] ++ [ wrappedBins ];
  };

  meta.maintainers = with lib.maintainers; [ peterhoeg ];
}
