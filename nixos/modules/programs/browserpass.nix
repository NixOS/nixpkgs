{
  config,
  lib,
  pkgs,
  ...
}:

{

  options.programs.browserpass.enable = lib.mkEnableOption "Browserpass native messaging host";

  config = lib.mkIf config.programs.browserpass.enable {
    # chromium and chrome native messaging hosts
    programs.chromium.nativeMessagingHosts.packages = [
      (
        let
          host = "${pkgs.browserpass}/lib/browserpass/hosts/chromium/com.github.browserpass.native.json";
        in
        pkgs.linkFarm "browserpass-chromium-native-messaging-host" {
          "etc/chromium/native-messaging-hosts/com.github.browserpass.native.json" = host;
          "etc/opt/chrome/native-messaging-hosts/com.github.browserpass.native.json" = host;
        }
      )
    ];

    environment.etc =
      let
        appId = "com.github.browserpass.native.json";
        source = part: "${pkgs.browserpass}/lib/browserpass/${part}/${appId}";
      in
      {
        # chromium
        "chromium/policies/managed/${appId}".source = source "policies/chromium";

        # chrome
        "opt/chrome/policies/managed/${appId}".source = source "policies/chromium";

        # vivaldi
        "opt/vivaldi/native-messaging-hosts/${appId}".source = source "hosts/chromium";
        "opt/vivaldi/policies/managed/${appId}".source = source "policies/chromium";

        # brave
        "opt/brave/native-messaging-hosts/${appId}".source = source "hosts/chromium";
        "opt/brave/policies/managed/${appId}".source = source "policies/chromium";
      };
    programs.firefox.nativeMessagingHosts.packages = [ pkgs.browserpass ];
  };
}
