{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kanata;

  keyboard = {
    options = {
      device = mkOption {
        type = types.str;
        example = "/dev/input/by-id/usb-0000_0000-event-kbd";
        description = "Path to the keyboard device.";
      };
      config = mkOption {
        type = types.lines;
        example = ''
          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl)

          (deflayer qwerty
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            @cap a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl)

          (defalias
            ;; tap within 100ms for capslk, hold more than 100ms for lctl
            cap (tap-hold 100 100 caps lctl))
        '';
        description = ''
          Configuration other than defcfg.
          See <link xlink:href="https://github.com/jtroo/kanata"/> for more information.
        '';
      };
      extraDefCfg = mkOption {
        type = types.lines;
        default = "";
        example = "danger-enable-cmd yes";
        description = ''
          Configuration of defcfg other than linux-dev.
          See <link xlink:href="https://github.com/jtroo/kanata"/> for more information.
        '';
      };
    };
  };

  mkName = name: "kanata-${name}";

  mkConfig = name: keyboard: pkgs.writeText "${mkName name}-config.kdb" ''
    (defcfg
      ${keyboard.extraDefCfg}
      linux-dev ${keyboard.device})

    ${keyboard.config}
  '';

  mkService = name: keyboard: nameValuePair (mkName name) {
    description = "kanata for ${keyboard.device}";

    # Because path units are used to activate service units, which
    # will start the old stopped services during "nixos-rebuild
    # switch", stopIfChanged here is a workaround to make sure new
    # services are running after "nixos-rebuild switch".
    stopIfChanged = false;

    serviceConfig = {
      ExecStart = ''
        ${cfg.package}/bin/kanata \
          --cfg ${mkConfig name keyboard}
      '';

      DynamicUser = true;
      SupplementaryGroups = with config.users.groups; [
        input.name
        uinput.name
      ];

      # hardening
      DeviceAllow = [
        "/dev/uinput w"
        "char-input r"
      ];
      CapabilityBoundingSet = "";
      DevicePolicy = "closed";
      IPAddressDeny = "any";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      PrivateNetwork = true;
      PrivateUsers = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      RestrictAddressFamilies = "none";
      RestrictNamespaces = true;
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
        "~@resources"
      ];
      UMask = "0077";
    };
  };

  mkPath = name: keyboard: nameValuePair (mkName name) {
    description = "kanata trigger for ${keyboard.device}";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathExists = keyboard.device;
    };
  };
in
{
  options.services.kanata = {
    enable = mkEnableOption "kanata";
    package = mkOption {
      type = types.package;
      default = pkgs.kanata;
      defaultText = lib.literalExpression "pkgs.kanata";
      example = lib.literalExpression "pkgs.kanata-with-cmd";
      description = ''
        kanata package to use.
        If you enable danger-enable-cmd, pkgs.kanata-with-cmd should be used.
      '';
    };
    keyboards = mkOption {
      type = types.attrsOf (types.submodule keyboard);
      default = { };
      description = "Keyboard configurations.";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.uinput.enable = true;

    systemd = {
      paths = mapAttrs' mkPath cfg.keyboards;
      services = mapAttrs' mkService cfg.keyboards;
    };
  };

  meta.maintainers = with lib.maintainers; [ linj ];
}
