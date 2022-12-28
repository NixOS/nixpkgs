{ config, lib, pkgs, ... }:

let
  cfg = config.programs.captive-browser;

  inherit (lib)
    concatStringsSep escapeShellArgs optionalString
    literalExpression mkEnableOption mkIf mkOption mkOptionDefault types;

  browserDefault = chromium: concatStringsSep " " [
    ''env XDG_CONFIG_HOME="$PREV_CONFIG_HOME"''
    ''${chromium}/bin/chromium''
    ''--user-data-dir=''${XDG_DATA_HOME:-$HOME/.local/share}/chromium-captive''
    ''--proxy-server="socks5://$PROXY"''
    ''--host-resolver-rules="MAP * ~NOTFOUND , EXCLUDE localhost"''
    ''--no-first-run''
    ''--new-window''
    ''--incognito''
    ''-no-default-browser-check''
    ''http://cache.nixos.org/''
  ];

  desktopItem = pkgs.makeDesktopItem {
    name = "captive-browser";
    desktopName = "Captive Portal Browser";
    exec = "/run/wrappers/bin/captive-browser";
    icon = "nix-snowflake";
    categories = [ "Network" ];
  };

in
{
  ###### interface

  options = {
    programs.captive-browser = {
      enable = mkEnableOption (lib.mdDoc "captive browser");

      package = mkOption {
        type = types.package;
        default = pkgs.captive-browser;
        defaultText = literalExpression "pkgs.captive-browser";
        description = lib.mdDoc "Which package to use for captive-browser";
      };

      interface = mkOption {
        type = types.str;
        description = lib.mdDoc "your public network interface (wlp3s0, wlan0, eth0, ...)";
      };

      # the options below are the same as in "captive-browser.toml"
      browser = mkOption {
        type = types.str;
        default = browserDefault pkgs.chromium;
        defaultText = literalExpression (browserDefault "\${pkgs.chromium}");
        description = lib.mdDoc ''
          The shell (/bin/sh) command executed once the proxy starts.
          When browser exits, the proxy exits. An extra env var PROXY is available.

          Here, we use a separate Chrome instance in Incognito mode, so that
          it can run (and be waited for) alongside the default one, and that
          it maintains no state across runs. To configure this browser open a
          normal window in it, settings will be preserved.

          @volth: chromium is to open a plain HTTP (not HTTPS nor redirect to HTTPS!) website.
                  upstream uses http://example.com but I have seen captive portals whose DNS server resolves "example.com" to 127.0.0.1
        '';
      };

      dhcp-dns = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The shell (/bin/sh) command executed to obtain the DHCP
          DNS server address. The first match of an IPv4 regex is used.
          IPv4 only, because let's be real, it's a captive portal.
        '';
      };

      socks5-addr = mkOption {
        type = types.str;
        default = "localhost:1666";
        description = lib.mdDoc "the listen address for the SOCKS5 proxy server";
      };

      bindInterface = mkOption {
        default = true;
        type = types.bool;
        description = lib.mdDoc ''
          Binds `captive-browser` to the network interface declared in
          `cfg.interface`. This can be used to avoid collisions
          with private subnets.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.runCommand "captive-browser-desktop-item" { } ''
        install -Dm444 -t $out/share/applications ${desktopItem}/share/applications/*.desktop
      '')
    ];

    programs.captive-browser.dhcp-dns =
      let
        iface = prefixes:
          optionalString cfg.bindInterface (escapeShellArgs (prefixes ++ [ cfg.interface ]));
      in
      mkOptionDefault (
        if config.networking.networkmanager.enable then
          "${pkgs.networkmanager}/bin/nmcli dev show ${iface []} | ${pkgs.gnugrep}/bin/fgrep IP4.DNS"
        else if config.networking.dhcpcd.enable then
          "${pkgs.dhcpcd}/bin/dhcpcd ${iface ["-U"]} | ${pkgs.gnugrep}/bin/fgrep domain_name_servers"
        else if config.networking.useNetworkd then
          "${cfg.package}/bin/systemd-networkd-dns ${iface []}"
        else
          "${config.security.wrapperDir}/udhcpc --quit --now -f ${iface ["-i"]} -O dns --script ${
          pkgs.writeShellScript "udhcp-script" ''
            if [ "$1" = bound ]; then
              echo "$dns"
            fi
          ''}"
      );

    security.wrappers.udhcpc = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+p";
      source = "${pkgs.busybox}/bin/udhcpc";
    };

    security.wrappers.captive-browser = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+p";
      source = pkgs.writeShellScript "captive-browser" ''
        export PREV_CONFIG_HOME="$XDG_CONFIG_HOME"
        export XDG_CONFIG_HOME=${pkgs.writeTextDir "captive-browser.toml" ''
                                  browser = """${cfg.browser}"""
                                  dhcp-dns = """${cfg.dhcp-dns}"""
                                  socks5-addr = """${cfg.socks5-addr}"""
                                  ${optionalString cfg.bindInterface ''
                                    bind-device = """${cfg.interface}"""
                                  ''}
                                ''}
        exec ${cfg.package}/bin/captive-browser
      '';
    };
  };
}
