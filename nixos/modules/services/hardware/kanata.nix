{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.services.kanata;

  keyboard = {
    options = {
      devices = mkOption {
        type = types.addCheck (types.listOf types.str)
          (devices: (length devices) > 0);
        example = [ "/dev/input/by-id/usb-0000_0000-event-kbd" ];
        # TODO replace note with tip, which has not been implemented yet in
        # nixos/lib/make-options-doc/mergeJSON.py
        description = mdDoc ''
          Paths to keyboard devices.

          ::: {.note}
          To avoid unnecessary triggers of the service unit, unplug devices in
          the order of the list.
          :::
        '';
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
        description = mdDoc ''
          Configuration other than `defcfg`. See [example config
          files](https://github.com/jtroo/kanata) for more information.
        '';
      };
      extraDefCfg = mkOption {
        type = types.lines;
        default = "";
        example = "danger-enable-cmd yes";
        description = mdDoc ''
          Configuration of `defcfg` other than `linux-dev`. See [example
          config files](https://github.com/jtroo/kanata) for more information.
        '';
      };
      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = mdDoc "Extra command line arguments passed to kanata.";
      };
      port = mkOption {
        type = types.nullOr types.port;
        default = null;
        example = 6666;
        description = mdDoc ''
          Port to run the notification server on. `null` will not run the
          server.
        '';
      };
    };
  };

  mkName = name: "kanata-${name}";

  mkDevices = devices: concatStringsSep ":" devices;

  mkConfig = name: keyboard: pkgs.writeText "${mkName name}-config.kdb" ''
    (defcfg
      ${keyboard.extraDefCfg}
      linux-dev ${mkDevices keyboard.devices})

    ${keyboard.config}
  '';

  mkService = name: keyboard: nameValuePair (mkName name) {
    description = "kanata for ${mkDevices keyboard.devices}";

    # Because path units are used to activate service units, which
    # will start the old stopped services during "nixos-rebuild
    # switch", stopIfChanged here is a workaround to make sure new
    # services are running after "nixos-rebuild switch".
    stopIfChanged = false;

    serviceConfig = {
      ExecStart = ''
        ${cfg.package}/bin/kanata \
          --cfg ${mkConfig name keyboard} \
          --symlink-path ''${RUNTIME_DIRECTORY}/${name} \
          ${optionalString (keyboard.port != null) "--port ${toString keyboard.port}"} \
          ${utils.escapeSystemdExecArgs keyboard.extraArgs}
      '';

      DynamicUser = true;
      RuntimeDirectory = mkName name;
      SupplementaryGroups = with config.users.groups; [
        input.name
        uinput.name
      ];

      # hardening
      DeviceAllow = [
        "/dev/uinput rw"
        "char-input r"
      ];
      CapabilityBoundingSet = [ "" ];
      DevicePolicy = "closed";
      IPAddressAllow = optional (keyboard.port != null) "localhost";
      IPAddressDeny = [ "any" ];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      PrivateNetwork = keyboard.port == null;
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
      RestrictAddressFamilies =
        if (keyboard.port == null) then "none" else [ "AF_INET" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      SystemCallArchitectures = [ "native" ];
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
        "~@resources"
      ];
      UMask = "0077";
    };
  };

  mkPathName = i: name: "${mkName name}-${toString i}";

  mkPath = name: n: i: device:
    nameValuePair (mkPathName i name) {
      description =
        "${toString (i+1)}/${toString n} kanata trigger for ${name}, watching ${device}";
      wantedBy = optional (i == 0) "multi-user.target";
      pathConfig = {
        PathExists = device;
        # (ab)use systemd.path to construct a trigger chain so that the
        # service unit is only started when all paths exist
        # however, manual of systemd.path says Unit's suffix is not ".path"
        Unit =
          if (i + 1) == n
          then "${mkName name}.service"
          else "${mkPathName (i + 1) name}.path";
      };
      unitConfig.StopPropagatedFrom = optional (i > 0) "${mkName name}.service";
    };

  mkPaths = name: keyboard:
    let
      n = length keyboard.devices;
    in
    imap0 (mkPath name n) keyboard.devices
  ;
in
{
  options.services.kanata = {
    enable = mkEnableOption "kanata";
    package = mkOption {
      type = types.package;
      default = pkgs.kanata;
      defaultText = literalExpression "pkgs.kanata";
      example = literalExpression "pkgs.kanata-with-cmd";
      description = mdDoc ''
        The kanata package to use.

        ::: {.note}
        If `danger-enable-cmd` is enabled in any of the keyboards, the
        `kanata-with-cmd` package should be used.
        :::
      '';
    };
    keyboards = mkOption {
      type = types.attrsOf (types.submodule keyboard);
      default = { };
      description = mdDoc "Keyboard configurations.";
    };
  };

  config = mkIf cfg.enable {
    hardware.uinput.enable = true;

    systemd = {
      paths = trivial.pipe cfg.keyboards [
        (mapAttrsToList mkPaths)
        concatLists
        listToAttrs
      ];
      services = mapAttrs' mkService cfg.keyboards;
    };
  };

  meta.maintainers = with maintainers; [ linj ];
}
