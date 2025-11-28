{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.sylkserver;
  settingsFormat = pkgs.formats.ini { };
in

{
  freeformType = settingsFormat.type;
  options = {
    Conference = {
      file_transfer_dir = lib.mkOption {
        type = lib.types.path;
        default = cfg.stateDir;
        defaultText = lib.literalExpression "config.services.sylkserver.stateDir";
        description = "Directory for storing files transferred to rooms.";
      };
      screensharing_images_dir = lib.mkOption {
        type = lib.types.path;
        default = "${cfg.stateDir}/conference/screensharing";
        defaultText = lib.literalExpression "\"\${config.services.sylkserver.stateDir}/conference/screensharing\"";
        description = "Directory where images used by the Screen Sharing functionality will be stored.";
      };
    };
  };
}
