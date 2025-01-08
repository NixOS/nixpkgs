{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption mkPackageOption;
  inherit (lib)
    foldl'
    isList
    head
    elem
    mapAttrsToList
    concatMapAttrs
    optionalAttrs
    optional
    ;
  inherit (lib)
    stringLength
    substring
    lowerChars
    optionalString
    toUpper
    boolToString
    concatStrings
    isBool
    ;
  inherit (lib) mkIf getExe types;

  # Convert name from camel case (e.g. disable2FARemember) to upper case snake case (e.g. DISABLE_2FA_REMEMBER).
  nameToEnvVar =
    name:
    let
      parts = builtins.split "([A-Z0-9]+)" name;
      partsToEnvVar =
        parts:
        foldl' (
          key: x:
          let
            last = stringLength key - 1;
          in
          if isList x then
            key + optionalString (key != "" && substring last 1 key != "_") "_" + head x
          else if key != "" && elem (substring 0 1 x) lowerChars then # to handle e.g. [ "disable" [ "2FAR" ] "emember" ]
            substring 0 last key
            + optionalString (substring (last - 1) 1 key != "_") "_"
            + substring last 1 key
            + toUpper x
          else
            key + toUpper x
        ) "" parts;
    in
    if builtins.match "[A-Z0-9_]+" name != null then name else partsToEnvVar parts;

  cfg = config.services.snips-sh;

  # Due to the different naming schemes allowed for config keys,
  # we can only check for values consistently after converting them to their corresponding environment variable name.
  configFile = pkgs.writeText "snips-sh.env" (
    concatStrings (
      mapAttrsToList (name: value: "${name}=${value}\n") (
        concatMapAttrs (
          name: value:
          optionalAttrs (value != null) {
            ${nameToEnvVar name} = if isBool value then boolToString value else toString value;
          }
        ) cfg.settings
      )
    )
  );
in
{
  options.services.snips-sh = {
    enable = mkEnableOption "snips.sh";
    package = mkPackageOption pkgs "snips-sh" {
      example = "pkgs.snips-sh.override {withTensorflow = true;}";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/snips-sh";
      description = "The state directory of the service";
    };

    user = mkOption {
      type = types.str;
      default = "snips";
      description = "User to run snips.sh service as.";
    };

    group = mkOption {
      type = types.str;
      default = "snips";
      description = "Group to run snips.sh service as.";
    };

    settings = mkOption {
      type =
        with types;
        attrsOf (
          nullOr (oneOf [
            bool
            int
            str
          ])
        );

      default = { };
      example = {
        SNIPS_HTTP_INTERNAL = "http://0.0.0.0:8080";
        SNIPS_SSH_INTERNAL = "ssh://0.0.0.0:2222";
      };

      description = ''
        The configuration of snips-sh is done through environment variables,
        therefore it is recommended to use upper snake case (e.g. {env}`SNIPS_HTTP_INTERNAL`).

        However, camel case (e.g. `snipsSshInternal`) is also supported:
        The NixOS module will convert it automatically to
        upper case snake case (e.g. {env}`SNIPS_SSH_INTERNAL`).
        In this conversion digits (0-9) are handled just like upper case characters,
        so `foo2` would be converted to {env}`FOO_2`.
        Names already in this format remain unchanged, so `FOO2` remains `FOO2` if passed as such,
        even though `foo2` would have been converted to {env}`FOO_2`.
        This allows working around any potential future conflicting naming conventions.

        Based on the attributes passed to this config option an environment file will be generated
        that is passed to snips-sh's systemd service.

        The available configuration options can be found in
        [self-hostiing guide](https://github.com/robherley/snips.sh/blob/main/docs/self-hosting.md#configuration) to
        find about the environment variables you can use.
      '';
    };

    environmentFile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = "/etc/snips-sh.env";
      description = ''
        Additional environment file as defined in {manpage}`systemd.exec(5)`.

        Sensitive secrets such as {env}`SNIPS_SSH_HOSTKEYPATH` and {env}`SNIPS_METRICS_STATSD`
        may be passed to the service while avoiding potentially making them world-readable in the nix store or
        to convert an existing non-nix installation with minimum hassle.

        Note that this file needs to be available on the host on which
        `snips-sh` is running.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.groups.${cfg.group} = mkIf (cfg.group == "snips") { };
    users.users.${cfg.user} = mkIf (cfg.user == "snips") {
      inherit (cfg) group;
      isSystemUser = true;
    };

    systemd.services.snips-sh = {
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = [ configFile ] ++ optional (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = "${getExe cfg.package}";
        LimitNOFILE = "1048576";
        PrivateTmp = "true";
        PrivateDevices = "true";
        ProtectHome = "true";
        ProtectSystem = "strict";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        StateDirectory = cfg.stateDir;
        WorkingDirectory = "snips-sh";
        StateDirectoryMode = "0700";
        Restart = "always";
      };
    };

    systemd.tmpfiles.rules = [
      "D ${cfg.stateDir}/data 755 ${cfg.user} ${cfg.group} - -"
    ];
  };
}
