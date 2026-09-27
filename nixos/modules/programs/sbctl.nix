{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.sbctl;

  mkPathOption =
    default: description:
    lib.mkOption {
      inherit default;
      inherit description;
      type = lib.types.oneOf [
        lib.types.path
        lib.types.str
      ];
    };

  mkKeyOption = name: {
    public = mkPathOption "/var/lib/sbctl/keys/${name}/${name}.pem" "Public key";
    private = mkPathOption "/var/lib/sbctl/keys/${name}/${name}.key" "Private key";
  };
in
{
  options.programs.sbctl = {
    enable = lib.mkEnableOption "sbctl";
    package = lib.mkPackageOption pkgs "sbctl" { };
    settings = {
      landlock = lib.mkEnableOption "landlock" // {
        default = true;
      };
      guid = mkPathOption "/var/lib/sbctl/GUID" "The file containing the GUID";
      keys = {
        platform = mkKeyOption "PK";
        kek = mkKeyOption "KEK";
        db = mkKeyOption "db";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.etc."sbctl/sbctl.conf".text = ''
      landlock: ${if cfg.settings.landlock then "true" else "false"}
      guid: ${cfg.settings.guid}
      keys:
        pk:
          privkey: ${cfg.settings.keys.platform.private}
          pubkey: ${cfg.settings.keys.platform.public}
          type: file
        kek:
          privkey: ${cfg.settings.keys.kek.private}
          pubkey: ${cfg.settings.keys.kek.public}
          type: file
        db:
          privkey: ${cfg.settings.keys.db.private}
          pubkey: ${cfg.settings.keys.db.public}
          type: file
    '';
  };
}
