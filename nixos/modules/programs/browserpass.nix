{ config, lib, pkgs, ... }:

with lib;

{

  options.programs.browserpass.enable = mkEnableOption "Browserpass native messaging host";

  config = mkIf config.programs.browserpass.enable {
    environment.etc = let
      appId = "com.github.browserpass.native.json";
      source = part: "${pkgs.browserpass}/lib/browserpass/${part}/${appId}";
    in {
      # chromium
      "chromium/native-messaging-hosts/${appId}".source = source "hosts/chromium";
      "chromium/policies/managed/${appId}".source = source "policies/chromium";

      # chrome
      "opt/chrome/native-messaging-hosts/${appId}".source = source "hosts/chromium";
      "opt/chrome/policies/managed/${appId}".source = source "policies/chromium";

      # vivaldi
      "opt/vivaldi/native-messaging-hosts/${appId}".source = source "hosts/chromium";
      "opt/vivaldi/policies/managed/${appId}".source = source "policies/chromium";

      # brave
      "opt/brave/native-messaging-hosts/${appId}".source = source "hosts/chromium";
      "opt/brave/policies/managed/${appId}".source = source "policies/chromium";
    }
    # As with the v2 backwards compatibility in the pkgs.browserpass
    # declaration, this part can be removed once the browser extension
    # auto-updates to v3 (planned 2019-04-13, see
    # https://github.com/browserpass/browserpass-native/issues/31)
    // {
      "chromium/native-messaging-hosts/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/etc/chrome-host.json";
      "chromium/policies/managed/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/etc/chrome-policy.json";
      "opt/chrome/native-messaging-hosts/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/etc/chrome-host.json";
      "opt/chrome/policies/managed/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/etc/chrome-policy.json";
    };
    nixpkgs.config.firefox.enableBrowserpass = true;
  };
}
