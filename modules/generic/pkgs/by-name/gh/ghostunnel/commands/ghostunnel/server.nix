# Command line of `ghostunnel server`, in a module that is not specific to a
# module class. `pkgs/by-name/gh/ghostunnel/service.nix`, the NixOS module
# `services.ghostunnel` and `passthru.commandModules.ghostunnel.commands.server`
# of `pkgs.ghostunnel` use it. The options that all subcommands share are in
# `../ghostunnel.nix`. See "Modules of a package" in the Nixpkgs manual for why
# it is in this directory.
#
# The consumer sets `package` and gives `assertions` and `warnings` to the root
# of its configuration. The consumer also gives the files in
# `credentials` to the program, for example as systemd credentials. Thus this
# module does not add them to `portable.argv`.

{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkIf
    mkOption
    types
    ;
in
{
  imports = [ ../ghostunnel.nix ];

  options = {
    listen = mkOption {
      description = ''
        Address and port to listen on (can be HOST:PORT, unix:PATH).
      '';
      type = types.str;
    };

    target = mkOption {
      description = ''
        Address to forward connections to (can be HOST:PORT or unix:PATH).
      '';
      type = types.str;
    };

    disableAuthentication = mkOption {
      description = ''
        Disable client authentication, no client certificate will be required.
      '';
      type = types.bool;
      default = false;
    };

    allowAll = mkOption {
      description = ''
        If true, allow all clients, do not check client cert subject.
      '';
      type = types.bool;
      default = false;
    };

    allowCN = mkOption {
      description = ''
        Allow client if common name appears in the list.
      '';
      type = types.listOf types.str;
      default = [ ];
    };

    allowOU = mkOption {
      description = ''
        Allow client if organizational unit name appears in the list.
      '';
      type = types.listOf types.str;
      default = [ ];
    };

    allowDNS = mkOption {
      description = ''
        Allow client if DNS subject alternative name appears in the list.
      '';
      type = types.listOf types.str;
      default = [ ];
    };

    allowURI = mkOption {
      description = ''
        Allow client if URI subject alternative name appears in the list.
      '';
      type = types.listOf types.str;
      default = [ ];
    };

    unsafeTarget = mkOption {
      description = ''
        If set, does not limit target to localhost, 127.0.0.1, [::1], or UNIX sockets.

        This is meant to protect against accidental unencrypted traffic on
        untrusted networks.
      '';
      type = types.bool;
      default = false;
    };
  };

  config = {
    assertions = [
      {
        message = ''
          At least one access control flag is required.
          Set at least one of:
            - ${options.disableAuthentication}
            - ${options.allowAll}
            - ${options.allowCN}
            - ${options.allowOU}
            - ${options.allowDNS}
            - ${options.allowURI}
        '';
        assertion =
          config.disableAuthentication
          || config.allowAll
          || config.allowCN != [ ]
          || config.allowOU != [ ]
          || config.allowDNS != [ ]
          || config.allowURI != [ ];
      }
    ];

    # Clients should not be authenticated with the public root certificates
    # (afaict, it doesn't make sense), so we only provide that default when
    # client cert auth is disabled.
    cacert = mkIf config.disableAuthentication (mkDefault null);

    portable.argv = [ "server" ];

    portable.flags = [
      { "--listen" = config.listen; }
      { "--target" = config.target; }
      { "--allow-all" = config.allowAll; }
    ]
    ++ map (v: { "--allow-cn" = v; }) config.allowCN
    ++ map (v: { "--allow-ou" = v; }) config.allowOU
    ++ map (v: { "--allow-dns" = v; }) config.allowDNS
    ++ map (v: { "--allow-uri" = v; }) config.allowURI
    ++ [
      { "--disable-authentication" = config.disableAuthentication; }
      { "--unsafe-target" = config.unsafeTarget; }
    ];
  };
}
