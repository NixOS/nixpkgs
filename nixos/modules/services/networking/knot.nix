{ config, lib, pkgs, utils, ... }:


let
  inherit (lib)
    attrNames
    concatMapStrings
    concatMapStringsSep
    concatStrings
    concatStringsSep
    elem
    filter
    flip
    hasAttr
    hasPrefix
    isAttrs
    isBool
    isDerivation
    isList
    mapAttrsToList
    mkChangedOptionModule
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionals
    types
  ;

  inherit (utils)
    escapeSystemdExecArgs
  ;

  cfg = config.services.knot;

  yamlConfig = let
    result = assert secsCheck; nix2yaml cfg.settings;

    secAllow = n: hasPrefix "mod-" n || elem n [
      "module"
      "server" "xdp" "control"
      "log"
      "statistics" "database"
      "keystore" "key" "remote" "remotes" "acl" "submission" "policy"
      "template"
      "zone"
      "include"
    ];
    secsCheck = let
      secsBad = filter (n: !secAllow n) (attrNames cfg.settings);
    in if secsBad == [] then true else throw
      ("services.knot.settings contains unknown sections: " + toString secsBad);

    nix2yaml = nix_def: concatStrings (
        # We output the config section in the upstream-mandated order.
        # Ordering is important due to forward-references not being allowed.
        # See definition of conf_export and 'const yp_item_t conf_schema'
        # upstream for reference.  Last updated for 3.3.
        # When changing the set of sections, also update secAllow above.
        [ (sec_list_fa "id" nix_def "module") ]
        ++ map (sec_plain nix_def)
          [ "server" "xdp" "control" ]
        ++ [ (sec_list_fa "target" nix_def "log") ]
        ++ map (sec_plain nix_def)
          [  "statistics" "database" ]
        ++ map (sec_list_fa "id" nix_def)
          [ "keystore" "key" "remote" "remotes" "acl" "submission" "policy" ]

        # Export module sections before the template section.
        ++ map (sec_list_fa "id" nix_def) (filter (hasPrefix "mod-") (attrNames nix_def))

        ++ [ (sec_list_fa "id" nix_def "template") ]
        ++ [ (sec_list_fa "domain" nix_def "zone") ]
        ++ [ (sec_plain nix_def "include") ]
        ++ [ (sec_plain nix_def "clear") ]
      );

    # A plain section contains directly attributes (we don't really check that ATM).
    sec_plain = nix_def: sec_name: if !hasAttr sec_name nix_def then "" else
      n2y "" { ${sec_name} = nix_def.${sec_name}; };

    # This section contains a list of attribute sets.  In each of the sets
    # there's an attribute (`fa_name`, typically "id") that must exist and come first.
    # Alternatively we support using attribute sets instead of lists; example diff:
    # -template = [ { id = "default"; /* other attributes */ }   { id = "foo"; } ]
    # +template = { default = {       /* those attributes */ };  foo = { };      }
    sec_list_fa = fa_name: nix_def: sec_name: if !hasAttr sec_name nix_def then "" else
      let
        elem2yaml = fa_val: other_attrs:
          "  - " + n2y "" { ${fa_name} = fa_val; }
          + "    " + n2y "    " other_attrs
          + "\n";
        sec = nix_def.${sec_name};
      in
        sec_name + ":\n" +
          (if isList sec
            then flip concatMapStrings sec
              (elem: elem2yaml elem.${fa_name} (removeAttrs elem [ fa_name ]))
            else concatStrings (mapAttrsToList elem2yaml sec)
          );

    # This convertor doesn't care about ordering of attributes.
    # TODO: it could probably be simplified even more, now that it's not
    # to be used directly, but we might want some other tweaks, too.
    n2y = indent: val:
      if doRecurse val then concatStringsSep "\n${indent}"
        (mapAttrsToList
          # This is a bit wacky - set directly under a set would start on bad indent,
          # so we start those on a new line, but not other types of attribute values.
          (aname: aval: "${aname}:${if doRecurse aval then "\n${indent}  " else " "}"
            + n2y (indent + "  ") aval)
          val
        )
        + "\n"
        else
      /*
      if isList val && stringLength indent < 4 then concatMapStrings
        (elem: "\n${indent}- " + n2y (indent + "  ") elem)
        val
        else
      */
      if isList val /* and long indent */ then
        "[ " + concatMapStringsSep ", " quoteString val + " ]" else
      if isBool val then (if val then "on" else "off") else
      quoteString val;

    # We don't want paths like ./my-zone.txt be converted to plain strings.
    quoteString = s: ''"${if builtins.typeOf s == "path" then s else toString s}"'';
    # We don't want to walk the insides of derivation attributes.
    doRecurse = val: isAttrs val && !isDerivation val;

  in result;

  configFile = if cfg.settingsFile != null then
    # Note: with extraConfig, the 23.05 compat code did include keyFiles from settingsFile.
    assert cfg.settings == {} && (cfg.keyFiles == [] || cfg.extraConfig != null);
    cfg.settingsFile
  else
    mkConfigFile yamlConfig;

  mkConfigFile = configString: pkgs.writeTextFile {
    name = "knot.conf";
    text = (concatMapStringsSep "\n" (file: "include: ${file}") cfg.keyFiles) + "\n" + configString;
    checkPhase = lib.optionalString cfg.checkConfig ''
      ${cfg.package}/bin/knotc --config=$out conf-check
    '';
  };

  socketFile = "/run/knot/knot.sock";

  knot-cli-wrappers = pkgs.stdenv.mkDerivation {
    name = "knot-cli-wrappers";
    nativeBuildInputs = [ pkgs.makeWrapper ];
    buildCommand = ''
      mkdir -p $out/bin
      makeWrapper ${cfg.package}/bin/knotc "$out/bin/knotc" \
        --add-flags "--config=${configFile}" \
        --add-flags "--socket=${socketFile}"
      makeWrapper ${cfg.package}/bin/keymgr "$out/bin/keymgr" \
        --add-flags "--config=${configFile}"
      for executable in kdig khost kjournalprint knsec3hash knsupdate kzonecheck
      do
        ln -s "${cfg.package}/bin/$executable" "$out/bin/$executable"
      done
      mkdir -p "$out/share"
      ln -s '${cfg.package}/share/man' "$out/share/"
    '';
  };
in {
  options = {
    services.knot = {
      enable = mkEnableOption "Knot authoritative-only DNS server";

      enableXDP = mkOption {
        type = types.bool;
        default = lib.hasAttrByPath [ "xdp" "listen" ] cfg.settings;
        defaultText = ''
          Enabled when the `xdp.listen` setting is configured through `settings`.
        '';
        example = true;
        description = ''
          Extends the systemd unit with permissions to allow for the use of
          the eXpress Data Path (XDP).

          ::: {.note}
            Make sure to read up on functional [limitations](https://www.knot-dns.cz/docs/latest/singlehtml/index.html#mode-xdp-limitations)
            when running in XDP mode.
          :::
        '';
      };

      checkConfig = mkOption {
        type = types.bool;
        # TODO: maybe we could do some checks even when private keys complicate this?
        # conf-check fails hard on missing IPs/devices with XDP
        default = cfg.keyFiles == [] && !cfg.enableXDP;
        defaultText = ''
          Disabled when the config uses `keyFiles` or `enableXDP`.
        '';
        example = false;
        description = ''
          Toggles the configuration test at build time. It runs in a
          sandbox, and therefore cannot be used in all scenarios.
        '';
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of additional command line parameters for knotd
        '';
      };

      keyFiles = mkOption {
        type = types.listOf types.path;
        default = [];
        description = ''
          A list of files containing additional configuration
          to be included using the include directive. This option
          allows to include configuration like TSIG keys without
          exposing them to the nix store readable to any process.
          Note that using this option will also disable configuration
          checks at build time.
        '';
      };

      settings = mkOption {
        type = (pkgs.formats.yaml {}).type;
        default = {};
        description = ''
          Extra configuration as nix values.
        '';
      };

      settingsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          As alternative to ``settings``, you can provide whole configuration
          directly in the almost-YAML format of Knot DNS.
          You might want to utilize ``pkgs.writeText "knot.conf" "longConfigString"`` for this.
        '';
      };

      package = mkPackageOption pkgs "knot-dns" { };
    };
  };
  imports = [
    # Compatibility with NixOS 23.05.
    (mkChangedOptionModule [ "services" "knot" "extraConfig" ] [ "services" "knot" "settingsFile" ]
      (config: mkConfigFile config.services.knot.extraConfig)
    )
  ];

  config = mkIf config.services.knot.enable {
    users.groups.knot = {};
    users.users.knot = {
      isSystemUser = true;
      group = "knot";
      description = "Knot daemon user";
    };

    environment.etc."knot/knot.conf".source = configFile; # just for user's convenience

    systemd.services.knot = {
      unitConfig.Documentation = "man:knotd(8) man:knot.conf(5) man:knotc(8) https://www.knot-dns.cz/docs/${cfg.package.version}/html/";
      description = cfg.package.meta.description;
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];
      after = ["network.target" ];

      serviceConfig = let
        # https://www.knot-dns.cz/docs/3.3/singlehtml/index.html#pre-requisites
        xdpCapabilities = lib.optionals (cfg.enableXDP) [
          "CAP_NET_ADMIN"
          "CAP_NET_RAW"
          "CAP_SYS_ADMIN"
          "CAP_IPC_LOCK"
        ] ++ lib.optionals (lib.versionOlder config.boot.kernelPackages.kernel.version "5.11") [
          "CAP_SYS_RESOURCE"
        ];
      in {
        Type = "notify";
        ExecStart = escapeSystemdExecArgs ([
          (lib.getExe cfg.package)
          "--config=${configFile}"
          "--socket=${socketFile}"
        ] ++ cfg.extraArgs);
        ExecReload = escapeSystemdExecArgs [
          "${knot-cli-wrappers}/bin/knotc" "reload"
        ];
        User = "knot";
        Group = "knot";

        AmbientCapabilities = [
          "CAP_NET_BIND_SERVICE"
        ] ++ xdpCapabilities;
        CapabilityBoundingSet = [
          "CAP_NET_BIND_SERVICE"
        ] ++ xdpCapabilities;
        DeviceAllow = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = false; # breaks capability passing
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        Restart = "on-abort";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ] ++ optionals (cfg.enableXDP) [
          "AF_NETLINK"
          "AF_XDP"
        ];
        RestrictNamespaces = true;
        RestrictRealtime =true;
        RestrictSUIDSGID = true;
        RuntimeDirectory = "knot";
        StateDirectory = "knot";
        StateDirectoryMode = "0700";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ] ++ optionals (cfg.enableXDP) [
          "bpf"
        ];
        UMask = "0077";
      };
    };

    environment.systemPackages = [ knot-cli-wrappers ];
  };
}
