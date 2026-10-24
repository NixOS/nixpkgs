{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.skwd-walld;
in
{
  options.services.skwd-walld = {
    enable = lib.mkEnableOption "Skwd Wall - An Awesome wallpaper suite ( not just selector )";

    enablePlasma = lib.mkEnableOption "Enable KDE Plasma support";

    enableSteamWorks = lib.mkEnableOption "Enable SteamWorks support";

    enableLens = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable/Disable the AI model";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Optional Deck backends such as skwd-deck-steamworks.";
    };

    modelPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.skwd-lens-model;
      defaultText = lib.literalExpression "pkgs.skwd-lens-model";
      description = "Semantic model pack used by Skwd Lens. The default SigLIP 2 pack is installed with the suite. Leave empty if you wanna disable the ai model";
    };

  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.skwd-wall-v2
      pkgs.skwd-deck
      pkgs.skwd-paper-v2
      cfg.modelPackage
    ]
    ++ cfg.extraPackages
    ++ lib.optional cfg.enablePlasma pkgs.skwd-paper-plasma
    ++ lib.optional cfg.enableLens pkgs.skwd-lens
    ++ lib.optional cfg.enableSteamWorks pkgs.skwd-deck-steamworks;

    environment.sessionVariables.SKWD_LENS_HOME = "${cfg.modelPackage}/share/skwd-lens/models/semantic";

    systemd.user.services.skwd-walld = {

      description = "skwd-wall control daemon";
      conflicts = [ "skwd-daemon.service" ];
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      path = [
        pkgs.skwd-paper-v2
        pkgs.skwd-lens
      ]
      ++ cfg.extraPackages;

      environment = {
        SKWD_LENS_HOME = "${cfg.modelPackage}/share/skwd-lens/models/semantic";
      };

      serviceConfig = {
        ExecStart = "${pkgs.skwd-deck}/bin/skwd-walld";
        Restart = "on-failure";
      };
    };

  };
}
