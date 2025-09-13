{
  lib,
  config,
  systemdPackage,
  ...
}:
let
  inherit (lib)
    concatMapStringsSep
    isDerivation
    isInt
    isFloat
    isPath
    isString
    mkOption
    replaceStrings
    types
    ;
  inherit (builtins) toJSON;

  # Local copy of systemd exec argument escaping function.
  # TODO: This could perhaps be deduplicated, but it is unclear where it should go.
  #       Preferably, we don't create a hard dependency on NixOS here, so that this
  #       module can be reused in a non-NixOS context, such as mutaable services
  #       in /run/systemd/system.

  # Quotes an argument for use in Exec* service lines.
  # systemd accepts "-quoted strings with escape sequences, toJSON produces
  # a subset of these.
  # Additionally we escape % to disallow expansion of % specifiers. Any lone ;
  # in the input will be turned it ";" and thus lose its special meaning.
  # Every $ is escaped to $$, this makes it unnecessary to disable environment
  # substitution for the directive.
  escapeSystemdExecArg =
    arg:
    let
      s =
        if isPath arg then
          "${arg}"
        else if isString arg then
          arg
        else if isInt arg || isFloat arg || isDerivation arg then
          toString arg
        else
          throw "escapeSystemdExecArg only allows strings, paths, numbers and derivations";
    in
    replaceStrings [ "%" "$" ] [ "%%" "$$" ] (toJSON s);

  # Quotes a list of arguments into a single string for use in a Exec*
  # line.
  escapeSystemdExecArgs = concatMapStringsSep " " escapeSystemdExecArg;

in
{
  _class = "service";
  imports = [
    (lib.mkAliasOptionModule [ "systemd" "service" ] [ "systemd" "services" "" ])
    (lib.mkAliasOptionModule [ "systemd" "socket" ] [ "systemd" "sockets" "" ])
  ];
  options = {
    systemd.services = mkOption {
      description = ''
        This module configures systemd services, with the notable difference that their unit names will be prefixed with the abstract service name.

        This option's value is not suitable for reading, but you can define a module here that interacts with just the unit configuration in the host system configuration.

        Note that this option contains _deferred_ modules.
        This means that the module has not been combined with the system configuration yet, no values can be read from this option.
        What you can do instead is define a module that reads from the module arguments (such as `config`) that are available when the module is merged into the system configuration.
      '';
      type = types.lazyAttrsOf (
        types.deferredModuleWith {
          staticModules = [
            # TODO: Add modules for the purpose of generating documentation?
          ];
        }
      );
      default = { };
    };
    systemd.sockets = mkOption {
      description = ''
        Declares systemd socket units. Names will be prefixed by the service name / path.

        See {option}`systemd.services`.
      '';
      type = types.lazyAttrsOf types.deferredModule;
      default = { };
    };

    # Also import systemd logic into sub-services
    # extends the portable `services` option
    services = mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          class = "service";
          modules = [
            ./service.nix
          ];
          specialArgs = {
            inherit systemdPackage;
          };
        }
      );
      # Rendered by the portable docs instead.
      visible = false;
    };
  };
  config = {
    # Note that this is the systemd.services option above, not the system one.
    systemd.services."" = {
      # TODO description;
      wantedBy = lib.mkDefault [ "multi-user.target" ];
      serviceConfig = {
        Type = lib.mkDefault "simple";
        Restart = lib.mkDefault "always";
        RestartSec = lib.mkDefault "5";
        ExecStart = [
          (escapeSystemdExecArgs config.process.argv)
        ];
      };
    };
  };
}
