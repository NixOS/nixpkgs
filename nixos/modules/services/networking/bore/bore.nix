{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.bore;
  inherit (lib)
    mkOption
    mkPackageOption
    mkEnableOption
    types
    optionalString
    ;
  inherit (types) attrsOf submodule;
in
{
  options = {
    services.bore = {
      package = mkPackageOption pkgs "bore-cli" { };

      local = mkOption {
        type = attrsOf (submodule ./local-options.nix);
        description = "Definition of bore local proxies.";
        default = { };
      };

      server = mkOption {
        type = attrsOf (submodule ./server-options.nix);
        description = "Definition of bore remote proxy servers.";
        default = { };
      };

      enableLocalPortCheck = mkEnableOption "local port check" // {
        default = true;
        example = false;
      };

      enableServerPortCheck = mkEnableOption "server port check" // {
        default = true;
        example = false;
      };
    };
  };

  config =
    let
      getEnabled = s: builtins.filter (value: value.enable) (lib.attrValues s);
      mkBoreService =
        kind: v:
        let
          isServer = (kind == "server");
        in
        {
          name = "bore-${kind}-${v.name}";
          value = {
            description = "bore remote proxy service for ${v.name}";
            enable = true;
            after = [
              "network-online.target"
              "nss-lookup.target"
            ];

            requires = [
              "network-online.target"
              "nss-lookup.target"
            ];

            wantedBy = [ "multi-user.target" ];

            environment =
              if isServer then
                {
                  BORE_MIN_PORT = toString v.min-port;
                  BORE_MAX_PORT = toString v.max-port;
                }
              else
                {
                  BORE_SERVER = v.to;
                  BORE_LOCAL_PORT = toString v.local-port;
                };

            script = ''
              ${optionalString (v.secretFile != null) ''export BORE_SECRET="$(<${v.secretFile})"''}

              ${lib.getExe' cfg.package "bore"} ${kind} \
            ''
            + (
              if isServer then
                ''--bind-addr="${v.bind-addr}" --bind-tunnels="${v.bind-tunnels}"''
              else
                ''--local-host="${v.local-host}" --port=${toString v.remote-port}''
            );

            serviceConfig = {
              Restart = "on-failure";
              RestartSec = 10;
            };
          };
        };
    in
    {
      systemd.services =
        (lib.genAttrs' (getEnabled cfg.server) (mkBoreService "server"))
        // (lib.genAttrs' (getEnabled cfg.local) (mkBoreService "local"));

      assertions =
        let
          localTuples = map (v: "${v.local-host}:${toString v.local-port}") (getEnabled cfg.local);

          # For remote tuples, filter out entries where remote-port == 0, since that's a legal default
          remoteTuples = map (v: "${v.to}:${toString v.remote-port}") (
            builtins.filter (v: v.remote-port != 0) (getEnabled cfg.local)
          );

          bindAddrs = map (v: v.bind-addr) (getEnabled cfg.server);

          findDuplicates =
            list:
            lib.pipe list [
              (builtins.groupBy toString)
              (builtins.mapAttrs (_: builtins.length))
              (lib.filterAttrs (_: len: len > 1))
              builtins.attrNames
            ];
        in
        [
          (lib.mkIf (cfg.enableLocalPortCheck) {
            assertion = lib.allUnique localTuples;
            message = ''
              Detected duplicate values of the following `local-host:local-port` tuples:
                ${lib.concatStringsSep ", " (findDuplicates localTuples)}
              Ensure these tuples are unique across attributes in `services.bore.local`!
              (To turn off this assertion, set `services.bore.enableLocalPortCheck = false;`)
            '';
          })

          (lib.mkIf (cfg.enableLocalPortCheck) {
            assertion = lib.allUnique remoteTuples;
            message = ''
              Detected duplicate values for `to:remote-port` tuples:
                ${lib.concatStringsSep ", " (findDuplicates remoteTuples)}
              Ensure these tuples are unique across attributes in `services.bore.local`!
              (To turn off this assertion, set `services.bore.enableLocalPortCheck = false;`)
            '';
          })

          (lib.mkIf (cfg.enableServerPortCheck) {
            assertion = lib.allUnique bindAddrs;
            message = ''
              Detected duplicate values for bore remote `bind-addr`s:
                ${lib.concatStringsSep ", " (findDuplicates bindAddrs)}
              Ensure `bind-addr` is unique across attributes in `services.bore.server`!
              (To turn off this assertion, set `services.bore.enableServerPortCheck = false;`)
            '';
          })
        ];
    };

  meta.maintainers = with lib.maintainers; [ zsuper ];
}
