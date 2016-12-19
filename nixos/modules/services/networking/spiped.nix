{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.spiped;
in
{
  options = {
    services.spiped = {
      enable = mkOption {
        type        = types.bool;
        default     = false;
        description = "Enable the spiped service module.";
      };

      config = mkOption {
        type = types.attrsOf (types.submodule (
          {
            options = {
              encrypt = mkOption {
                type    = types.bool;
                default = false;
                description = ''
                  Take unencrypted connections from the
                  <literal>source</literal> socket and send encrypted
                  connections to the <literal>target</literal> socket.
                '';
              };

              decrypt = mkOption {
                type    = types.bool;
                default = false;
                description = ''
                  Take encrypted connections from the
                  <literal>source</literal> socket and send unencrypted
                  connections to the <literal>target</literal> socket.
                '';
              };

              source = mkOption {
                type    = types.str;
                description = ''
                  Address on which spiped should listen for incoming
                  connections.  Must be in one of the following formats:
                  <literal>/absolute/path/to/unix/socket</literal>,
                  <literal>host.name:port</literal>,
                  <literal>[ip.v4.ad.dr]:port</literal> or
                  <literal>[ipv6::addr]:port</literal> - note that
                  hostnames are resolved when spiped is launched and are
                  not re-resolved later; thus if DNS entries change
                  spiped will continue to connect to the expired
                  address.
                '';
              };

              target = mkOption {
                type    = types.str;
                description = "Address to which spiped should connect.";
              };

              keyfile = mkOption {
                type    = types.path;
                description = ''
                  Name of a file containing the spiped key. As the
                  daemon runs as the <literal>spiped</literal> user, the
                  key file must be somewhere owned by that user. By
                  default, we recommend putting the keys for any spipe
                  services in <literal>/var/lib/spiped</literal>.
                '';
              };

              timeout = mkOption {
                type = types.int;
                default = 5;
                description = ''
                  Timeout, in seconds, after which an attempt to connect to
                  the target or a protocol handshake will be aborted (and the
                  connection dropped) if not completed
                '';
              };

              maxConns = mkOption {
                type = types.int;
                default = 100;
                description = ''
                  Limit on the number of simultaneous connections allowed.
                '';
              };

              waitForDNS = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Wait for DNS. Normally when <literal>spiped</literal> is
                  launched it resolves addresses and binds to its source
                  socket before the parent process returns; with this option
                  it will daemonize first and retry failed DNS lookups until
                  they succeed. This allows <literal>spiped</literal> to
                  launch even if DNS isn't set up yet, but at the expense of
                  losing the guarantee that once <literal>spiped</literal> has
                  finished launching it will be ready to create pipes.
                '';
              };

              disableKeepalives = mkOption {
                type = types.bool;
                default = false;
                description = "Disable transport layer keep-alives.";
              };

              weakHandshake = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Use fast/weak handshaking: This reduces the CPU time spent
                  in the initial connection setup, at the expense of losing
                  perfect forward secrecy.
                '';
              };

              resolveRefresh = mkOption {
                type = types.int;
                default = 60;
                description = ''
                  Resolution refresh time for the target socket, in seconds.
                '';
              };

              disableReresolution = mkOption {
                type = types.bool;
                default = false;
                description = "Disable target address re-resolution.";
              };
            };
          }
        ));

        default = {};

        example = literalExample ''
          {
            pipe1 =
              { keyfile = "/var/lib/spiped/pipe1.key";
                encrypt = true;
                source  = "localhost:6000";
                target  = "endpoint.example.com:7000";
              };
            pipe2 =
              { keyfile = "/var/lib/spiped/pipe2.key";
                decrypt = true;
                source  = "0.0.0.0:7000";
                target  = "localhost:3000";
              };
          }
        '';

        description = ''
          Configuration for a secure pipe daemon. The daemon can be
          started, stopped, or examined using
          <literal>systemctl</literal>, under the name
          <literal>spiped@foo</literal>.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = mapAttrsToList (name: c: {
      assertion = (c.encrypt -> !c.decrypt) || (c.decrypt -> c.encrypt);
      message   = "A pipe must either encrypt or decrypt";
    }) cfg.config;

    users.extraGroups.spiped.gid = config.ids.gids.spiped;
    users.extraUsers.spiped = {
      description = "Secure Pipe Service user";
      group       = "spiped";
      uid         = config.ids.uids.spiped;
    };

    systemd.services."spiped@" = {
      description = "Secure pipe '%i'";
      after       = [ "network.target" ];

      serviceConfig = {
        Restart   = "always";
        User      = "spiped";
        PermissionsStartOnly = true;
      };

      preStart  = ''
        cd /var/lib/spiped
        chmod -R 0660 *
        chown -R spiped:spiped *
      '';
      scriptArgs = "%i";
      script = "exec ${pkgs.spiped}/bin/spiped -F `cat /etc/spiped/$1.spec`";
    };

    system.activationScripts.spiped = optionalString (cfg.config != {})
      "mkdir -p /var/lib/spiped";

    # Setup spiped config files
    environment.etc = mapAttrs' (name: cfg: nameValuePair "spiped/${name}.spec"
      { text = concatStringsSep " "
          [ (if cfg.encrypt then "-e" else "-d")        # Mode
            "-s ${cfg.source}"                          # Source
            "-t ${cfg.target}"                          # Target
            "-k ${cfg.keyfile}"                         # Keyfile
            "-n ${toString cfg.maxConns}"               # Max number of conns
            "-o ${toString cfg.timeout}"                # Timeout
            (optionalString cfg.waitForDNS "-D")        # Wait for DNS
            (optionalString cfg.weakHandshake "-f")     # No PFS
            (optionalString cfg.disableKeepalives "-j") # Keepalives
            (if cfg.disableReresolution then "-R"
              else "-r ${toString cfg.resolveRefresh}")
          ];
      }) cfg.config;
  };
}
