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
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (command: binary: ''
        cat <<_EOF >$out/bin/${command}
        #! ${pkgs.runtimeShell} -e
        exec /run/wrappers/bin/firejail ${binary} "\$@"
        _EOF
        chmod 0755 $out/bin/${command}
      '') cfg.wrappedBinaries)}
    '';

in {
  options.programs.firejail = {
    enable = mkEnableOption "firejail";

    wrappedBinaries = mkOption {
      type = types.attrsOf types.path;
      default = {};
      example = literalExample ''
        {
          firefox = "''${lib.getBin pkgs.firefox}/bin/firefox";
          mpv = "''${lib.getBin pkgs.mpv}/bin/mpv";
        }
      '';
      description = ''
        Wrap the binaries in firejail and place them in the global path.
        </para>
        <para>
        You will get file collisions if you put the actual application binary in
        the global environment and applications started via .desktop files are
        not wrapped if they specify the absolute path to the binary.
      '';
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.firejail.source = "${lib.getBin pkgs.firejail}/bin/firejail";

    environment.systemPackages = [ pkgs.firejail ] ++ [ wrappedBins ];
  };

  meta.maintainers = with maintainers; [ peterhoeg ];
}
