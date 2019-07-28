{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.firejail;

  applicationBinaries =
    let
      withBinary = _: application: application.binary != null;
      toBinary = _: application: "${application.jailOptions} ${application.binary}";
    in
      mapAttrs toBinary (filterAttrs withBinary cfg.wrappedApplications);

  wrappedBins = pkgs.stdenv.mkDerivation rec {
    name = "firejail-wrapped-binaries";
    nativeBuildInputs = with pkgs; [ makeWrapper ];
    buildCommand = ''
      mkdir -p $out/bin
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (command: binary: ''
      cat <<_EOF >$out/bin/${command}
      #!${pkgs.stdenv.shell} -e
      /run/wrappers/bin/firejail ${binary} "\$@"
      _EOF
      chmod 0755 $out/bin/${command}
      '') (cfg.wrappedBinaries // applicationBinaries))}
    '';
  };

  wrappedApps = pkgs.stdenv.mkDerivation rec {
    name = "firejail-wrapped-applications";
    nativeBuildInputs = with pkgs; [ makeWrapper ];
    buildCommand = ''
      mkdir -p $out/share/applications
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: app: ''
      cat ${app.desktopFile} \
          | sed -e 's:^Exec\s*=:Exec=/run/wrappers/bin/firejail ${app.jailOptions}:' \
          > $out/share/applications/${name}.desktop
      chmod 0555 $out/share/applications/${name}.desktop
      '') cfg.wrappedApplications)}
    '';
  };

in {
  options.programs.firejail = {
    enable = mkEnableOption "firejail";

    wrappedBinaries = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Wrap the binaries in firejail and place them in the global path.
        </para>
        <para>
        You will get file collisions if you put the actual application binary in
        the global environment and applications started via .desktop files are
        not wrapped if they specify the absolute path to the binary.
      '';
    };

    wrappedApplications = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          binary = mkOption {
            type = types.nullOr types.string;
            description = ''
              If set, wrap the binary in firejail and place it in the global path.
            '';
          };
          desktopFile = mkOption {
            type = types.string;
            description = ''
              Wrap the desktop file 'Exec' in firejail.
            '';
          };
          jailOptions = mkOption {
            type = types.str;
            default = "";
            description = ''
              Options to pass on to firejail.
            '';
          };
        };
      });
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.firejail.source = "${lib.getBin pkgs.firejail}/bin/firejail";

    environment.systemPackages = [ wrappedBins wrappedApps ];
  };

  meta.maintainers = with maintainers; [ peterhoeg ];
}
