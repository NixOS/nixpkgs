{
  lib,
  nixos,
  runCommand,
}:
let
  passwordWarning = "services.hebbot.environment.BOT_PASSWORD will be overwritten by the startup script. Use services.hebbot.botPasswordFile instead.";
  hasPasswordWarning =
    enable: environment:
    lib.elem passwordWarning
      (nixos {
        system.stateVersion = "26.05";
        services.hebbot = {
          inherit enable environment;
          template = "/run/hebbot-template.md";
          botPasswordFile = "/run/hebbot-password";
          settings = {
            bot_user_id = "@hebbot:matrix.test";
            reporting_room_id = "!reporting:matrix.test";
            admin_room_id = "!admin:matrix.test";
          };
        };
      }).config.warnings;
in
assert !(hasPasswordWarning true { });
assert hasPasswordWarning true { BOT_PASSWORD = "unused-test-password"; };
assert hasPasswordWarning true { BOT_PASSWORD = ""; };
assert !(hasPasswordWarning false { BOT_PASSWORD = "unused-test-password"; });
runCommand "hebbot-module-options-test" { } ''
  touch "$out"
''
