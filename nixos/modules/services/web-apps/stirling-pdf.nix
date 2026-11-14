{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.strings)
    splitString
    ;
  cfg = config.services.stirling-pdf;
in
{
  imports =
    map
      (
        opt:
        lib.mkAliasOptionModule
          (
            [
              "services"
              "stirling-pdf"
            ]
            ++ splitString "." opt
          )
          (
            [
              "system"
              "services"
              "stirling-pdf"
              "stirling-pdf"
            ]
            ++ splitString "." opt
          )
      )
      [
        "package"
        "environment"
        "environmentFiles"
        "finalPackage"
        "systemd.stateDir"
        "systemd.user"
      ];

  options.services.stirling-pdf = {
    enable = lib.mkEnableOption "the stirling-pdf service";
  };

  config = lib.mkIf cfg.enable {
    system.services.stirling-pdf = {
      imports = [ pkgs.stirling-pdf.services.default ];
    };
  };

  meta.maintainers = with lib.maintainers; [
    DCsunset
    timhae
  ];
}
