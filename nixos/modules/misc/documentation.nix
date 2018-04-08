{ config, lib, pkgs, ... }:

with lib;

let cfg = config.documentation; in

{

  options = {

    documentation = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to install documentation of packages from
          <option>environment.systemPackages</option> into the generated system path.
        '';
      };

      man.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to install manual pages and the <command>man</command> command.
          This also includes "man" outputs.
        '';
      };

      doc.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to install documentation distributed in packages' <literal>/share/doc</literal>.
          Usually plain text and/or HTML.
          This also includes "doc" outputs.
        '';
      };

      info.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to install info pages and the <command>info</command> command.
          This also includes "info" outputs.
        '';
      };

    };

  };

  config = mkIf cfg.enable (mkMerge [

    (mkIf cfg.man.enable {
      environment.systemPackages = [ pkgs.man-db ];
      environment.pathsToLink = [ "/share/man" ];
      environment.extraOutputsToInstall = [ "man" ];
    })

    (mkIf cfg.doc.enable {
      # TODO(@oxij): put it here and remove from profiles?
      # environment.systemPackages = [ pkgs.w3m ]; # w3m-nox?
      environment.pathsToLink = [ "/share/doc" ];
      environment.extraOutputsToInstall = [ "doc" ];
    })

    (mkIf cfg.info.enable {
      environment.systemPackages = [ pkgs.texinfoInteractive ];
      environment.pathsToLink = [ "/share/info" ];
      environment.extraOutputsToInstall = [ "info" ];
    })

  ]);

}
