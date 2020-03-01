{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.knot;

  configFile = pkgs.writeTextFile {
    name = "knot.conf";
    text = (concatMapStringsSep "\n" (file: "include: ${file}") cfg.keyFiles) + "\n" +
           cfg.extraConfig;
    checkPhase = lib.optionalString (cfg.keyFiles == []) ''
      ${cfg.package}/bin/knotc --config=$out conf-check
    '';
  };

  socketFile = "/run/knot/knot.sock";

  knot-cli-wrappers = pkgs.stdenv.mkDerivation {
    name = "knot-cli-wrappers";
    buildInputs = [ pkgs.makeWrapper ];
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

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of additional command line paramters for knotd
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

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra lines to be added verbatim to knot.conf
        '';
      };

      nixConfig = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          Extra configuration as nix values.  EXPERIMENTAL!
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.knot-dns;
        defaultText = "pkgs.knot-dns";
        description = ''
          Which Knot DNS package to use
        '';
      };
    };
  };

  config = mkIf config.services.knot.enable {
    users.users.knot = {
      isSystemUser = true;
      group = "knot";
      description = "Knot daemon user";
    };

    users.groups.knot.gid = null;
    systemd.services.knot = {
      unitConfig.Documentation = "man:knotd(8) man:knot.conf(5) man:knotc(8) https://www.knot-dns.cz/docs/${cfg.package.version}/html/";
      description = cfg.package.meta.description;
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];
      after = ["network.target" ];

      serviceConfig = {
        Type = "notify";
        ExecStart = "${cfg.package}/bin/knotd --config=${configFile} --socket=${socketFile} ${concatStringsSep " " cfg.extraArgs}";
        ExecReload = "${knot-cli-wrappers}/bin/knotc reload";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE CAP_SETPCAP";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE CAP_SETPCAP";
        NoNewPrivileges = true;
        User = "knot";
        RuntimeDirectory = "knot";
        StateDirectory = "knot";
        StateDirectoryMode = "0700";
        PrivateDevices = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        SystemCallArchitectures = "native";
        Restart = "on-abort";
      };
    };

    environment.systemPackages = [ knot-cli-wrappers ];

    services.knot.extraConfig =
      let
        result = nix2yaml cfg.nixConfig;
        nix2yaml = nix_def: concatStrings (
            # We output the config section in the upstream-mandated order.
            # Ordering is important due to forward-references not being allowed.
            [ (sec_list_fa "id" nix_def "module") ]
            ++ map (sec_plain nix_def)
              [ "server" "control" ]
            ++ [ (sec_list_fa "target" nix_def "log") ]
            ++ map (sec_plain nix_def)
              [  "statistics" "database" ]
            ++ map (sec_list_fa "id" nix_def)
              [ "keystore" "key" "remote" "acl" "submission" "policy" "template" ]
            ++ [ (sec_list_fa "domain" nix_def "zone") ]
            ++ [ (sec_plain nix_def "include") ]
          );
          #FIXME: check that no other attributes are present? (silently omitted ATM)

        # A plain section contains directly attributes (we don't really check that ATM).
        sec_plain = nix_def: sec_name: if !hasAttr sec_name nix_def then "" else
          n2y "" { ${sec_name} = nix_def.${sec_name}; };

        # This section contains a list of attribute sets.  In each of the sets
        # there's an attribute (`fa_name`, typically "id") that must exist and come first.
        sec_list_fa = fa_name: nix_def: sec_name: if !hasAttr sec_name nix_def then "" else
          sec_name + ":\n"
          + (flip concatMapStrings) nix_def.${sec_name}
              (elem: "  - " + n2y "" { ${fa_name} = elem.${fa_name}; }
                + "    " + n2y "    " (removeAttrs elem [ fa_name ])
                + "\n"
              )
          ;

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
          quoteString val;

        # We don't want paths like ./my-zone.txt be converted to plain strings.
        quoteString = s: ''"${if builtins.typeOf s == "path" then s else toString s}"'';
        # We don't want to walk the insides of derivation attributes.
        doRecurse = val: isAttrs val && !isDerivation val;

      in result;
  };
}
