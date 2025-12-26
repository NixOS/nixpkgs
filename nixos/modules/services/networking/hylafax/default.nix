{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [
    ./options.nix
    ./systemd.nix
  ];

  config = lib.modules.mkIf config.services.hylafax.enable {
    environment.systemPackages = [ config.services.hylafax.package ];
    users.users.uucp = {
      uid = config.ids.uids.uucp;
      group = "uucp";
      description = "Unix-to-Unix CoPy system";
      isSystemUser = true;
      inherit (config.users.users.nobody) home;
    };
    assertions = [
      {
        assertion = config.services.hylafax.modems != { };
        message = ''
          HylaFAX cannot be used without modems.
          Please define at least one modem with
          <option>config.services.hylafax.modems</option>.
        '';
      }
    ];
  };

  meta.maintainers = [ lib.maintainers.yarny ];

}
