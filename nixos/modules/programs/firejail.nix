{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.firejail;
  fj=pkgs.firejail;

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
      '') cfg.wrappedBinaries)}
    '';
  };

in {
  options.programs.firejail = {
    enable = mkEnableOption "firejail";

    firecfg = mkEnableOption "automatic setup of links and desktop file via firecfg" // {
      default = true;
    };

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
  };

  config = mkIf cfg.enable {
    security.wrappers.firejail.source = "${lib.getBin fj}/bin/firejail";

    environment.systemPackages = [ wrappedBins ] ++ optional cfg.firecfg fj;

    environment.extraSetup = optionalString cfg.firecfg ''
      mkdir tmp
      cp -r $out tmp
      chroot tmp firecfg
    '';
  };

  meta.maintainers = with maintainers; [ peterhoeg ];
}
