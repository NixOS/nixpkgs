/*
  SPDX-License-Identifier: ISC AND MIT

  This file is licensed under the ISC License AND the MIT License.
  It contains code derived from https://github.com/daeuniverse/flake.nix

  --- ISC License ---
  Copyright (c) 2023, daeuniverse

  Permission to use, copy, modify, and/or distribute this software for any
  purpose with or without fee is hereby granted, provided that the above
  copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

  --- MIT License ---
  Copyright (c) 2026 Nixpkgs/NixOS contributors

  Licensed under the MIT License (the same license as the rest of Nixpkgs).
  The full text of the MIT License can be found in the LICENSE file at the
  root of this repository.
*/

{
  config,
  pkgs,
  lib,
  utils,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    literalExpression
    types
    mkPackageOption
    ;

  cfg = config.services.daed;
  inherit (cfg) assets;
  genAssetsDrv =
    paths:
    pkgs.symlinkJoin {
      name = "daed-assets";
      inherit paths;
    };
in
{
  options.services.daed = {
    enable = mkEnableOption "daed, a modern web dashboard with dae";

    package = mkPackageOption pkgs "daed" { };

    configDir = mkOption {
      type = types.str;
      default = "/etc/daed";
      description = "The daed work directory.";
    };

    listen = mkOption {
      type = types.str;
      default = "127.0.0.1:2023";
      description = "The daed listen address.";
    };

    assets = mkOption {
      type = with types; listOf path;
      default = with pkgs; [
        v2ray-geoip
        v2ray-domain-list-community
      ];
      defaultText = literalExpression "with pkgs; [ v2ray-geoip v2ray-domain-list-community ]";
      description = "Assets required to run daed.";
    };

    assetsPath = mkOption {
      type = types.str;
      default = "${genAssetsDrv assets}/share/v2ray";
      defaultText = literalExpression ''
        "''${pkgs.symlinkJoin {
          name = "daed-assets";
          paths = config.services.daed.assets;
        }}/share/v2ray"
      '';
      description = ''
        The path which contains geolocation database.
        This option will override `assets`.
      '';
    };

    openFirewall = {
      enable = mkEnableOption "opening `port` in the firewall";
      port = mkOption {
        type = types.port;
        default = 12345;
        description = ''
          Port to be opened. Consist with field `tproxy_port` in config file.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    networking = lib.mkIf cfg.openFirewall.enable {
      firewall =
        let
          portToOpen = cfg.openFirewall.port;
        in
        {
          allowedTCPPorts = [ portToOpen ];
          allowedUDPPorts = [ portToOpen ];
        };
    };

    systemd.services.daed = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = [
          ""
          (utils.escapeSystemdExecArgs [
            (lib.getExe cfg.package)
            "run"
            "-c"
            cfg.configDir
            "-l"
            cfg.listen
          ])
        ];
        Environment = "DAE_LOCATION_ASSET=${cfg.assetsPath}";

        # Hardening
        NoNewPrivileges = true;
        CapabilityBoundingSet = [
          "CAP_BPF"
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_ADMIN"
          "CAP_SYS_ADMIN"
        ];
        PrivateTmp = "disconnected";
        PrivateIPC = true;
        PrivateDevices = true;
        PrivateMounts = true;
        KeyringMode = "private";
        ProtectHome = "read-only";
        ProtectSystem = "strict";
        ReadWritePaths = [ cfg.configDir ];
        UMask = "0077";
        ProtectControlGroups = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = [ "net" ];
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@aio"
          "~@clock"
          "~@cpu-emulation"
          "~@debug"
          "~@keyring"
          "~@module"
          "~@obsolete"
          "~@pkey"
          "~@raw-io"
          "~@reboot"
          "~@resources"
          "~@sandbox"
          "~@setuid"
          "~@swap"
        ];
      };
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.configDir} 0750 root root - -"
    ];
  };
  meta.maintainers = with lib.maintainers; [ ccicnce113424 ];
}
