{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.orjail;

  wrappedBins = pkgs.runCommand "orjail-wrapped-binaries"
    { preferLocalBuild = true;
      allowSubstitutes = false;
    }
    ''
      mkdir -p $out/bin
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (command: value:
      let
        opts = if builtins.isAttrs value
        then value
        else { executable = value; extraArgs = []; };
        args = lib.escapeShellArgs ( opts.extraArgs );
      in
      ''
        cat <<_EOF >$out/bin/${command}
        #! ${pkgs.runtimeShell}
        exec ${pkgs.orjailWrapper}/bin/orjail ${args} ${toString opts.executable} "\$@"
        _EOF
        chmod 0755 $out/bin/${command}
      '') cfg.wrappedBinaries)}
    '';

in {
  options.programs.orjail = {
    enable = mkEnableOption "orjail";

    wrappedBinaries = mkOption {
      type = types.attrsOf (types.either types.path (types.submodule {
        options = {
          executable = mkOption {
            type = types.path;
            description = "Executable to run through Tor";
            example = literalExpression ''"''${lib.getBin pkgs.firefox}/bin/firefox"'';
          };
          extraArgs = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "Extra arguments to pass to orjail";
            example = [ "-f" ];
          };
        };
      }));
      default = {};
      example = literalExpression ''
        {
          firefox = {
            executable = "''${lib.getBin pkgs.firefox}/bin/firefox";
          };
          mpv = {
            executable = "''${lib.getBin pkgs.mpv}/bin/mpv";
          };
        }
      '';
      description = ''
        Wrap the binaries in orjail and place them in the global path.
        </para>
        <para>
        You will get file collisions if you put the actual application binary in
        the global environment (such as by adding the application package to
        <code>environment.systemPackages</code>), and applications started via
        .desktop files are not wrapped if they specify the absolute path to the
        binary.
      '';
    };
  };

  config = mkIf cfg.enable {

    programs.firejail.enable = true;

    nixpkgs.overlays = [
      (self: super: {
        orjailWrapper = super.orjail.overrideAttrs (old: {
	  patches = (old.patches or []) ++ [
  	    ./orjail_wrapper.patch
          ];
        });
      })
    ];

    environment.systemPackages = [ pkgs.orjail ] ++ [ wrappedBins ];

    systemd = {
      services.orjail = {
        wantedBy = [ "multi-user.target" ];
        description = "Orjail Service";
        after = [ "network.target" ];
        serviceConfig = {
	  Type = "oneshot";
	  ExecStart = "${pkgs.orjailWrapper}/bin/orjail -v -f -k :";
	};
      };
    };

  };

  meta.maintainers = with maintainers; [ onny ];
}
