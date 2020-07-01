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
    };
    nixpkgs.config.firefox.enableBrowserpass = true;
  };
}
