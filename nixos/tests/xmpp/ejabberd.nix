let
  cert =
    pkgs:
    pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
      openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -subj '/CN=example.com/CN=muc.example.com' -days 36500
      mkdir -p $out
      cp key.pem cert.pem $out
    '';
in
import ../make-test-python.nix (
  { pkgs, ... }:
  {
    name = "ejabberd";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ ];
    };
    nodes = {
      client =
        { nodes, pkgs, ... }:
        {
          security.pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
          networking.extraHosts = ''
            ${nodes.server.config.networking.primaryIPAddress} example.com
          '';

          environment.systemPackages = [
            (pkgs.callPackage ./xmpp-sendmessage.nix {
              connectTo = nodes.server.config.networking.primaryIPAddress;
            })
          ];
        };
      server =
        { config, pkgs, ... }:
        {
          security.pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
          networking.extraHosts = ''
            ${config.networking.primaryIPAddress} example.com
          '';

          services.ejabberd = {
            enable = true;
            configFile = "/etc/ejabberd.yml";
          };

          systemd.services.ejabberd.serviceConfig.TimeoutStartSec = "15min";
          environment.etc."ejabberd.yml" = {
            user = "ejabberd";
            mode = "0600";
            text = ''
              loglevel: 3

              hosts:
                - "example.com"

              listen:
                -
                  port: 5222
                  module: ejabberd_c2s
                  zlib: false
                  max_stanza_size: 65536
                  shaper: c2s_shaper
                  access: c2s
                  starttls: true
                -
                  port: 5269
                  ip: "::"
                  module: ejabberd_s2s_in
                -
                  port: 5347
                  ip: "127.0.0.1"
                  module: ejabberd_service
                  access: local
                  shaper: fast
                -
                  port: 5444
                  module: ejabberd_http
                  request_handlers:
                    "/upload": mod_http_upload

              certfiles:
                - ${cert pkgs}/key.pem
                - ${cert pkgs}/cert.pem

              ## Disabling digest-md5 SASL authentication. digest-md5 requires plain-text
              ## password storage (see auth_password_format option).
              disable_sasl_mechanisms: "digest-md5"

              ## Outgoing S2S options
              ## Preferred address families (which to try first) and connect timeout
              ## in seconds.
              outgoing_s2s_families:
                 - ipv4
                 - ipv6

              ## auth_method: Method used to authenticate the users.
              ## The default method is the internal.
              ## If you want to use a different method,
              ## comment this line and enable the correct ones.
              auth_method: internal

              ## Store the plain passwords or hashed for SCRAM:
              ## auth_password_format: plain
              auth_password_format: scram

              ###'  TRAFFIC SHAPERS
              shaper:
                # in B/s
                normal: 1000000
                fast: 50000000

              ## This option specifies the maximum number of elements in the queue
              ## of the FSM. Refer to the documentation for details.
              max_fsm_queue: 1000

              ###'   ACCESS CONTROL LISTS
              acl:
                ## The 'admin' ACL grants administrative privileges to XMPP accounts.
                ## You can put here as many accounts as you want.
                admin:
                   user:
                     - "root": "example.com"

                ## Local users: don't modify this.
                local:
                  user_regexp: ""

                ## Loopback network
                loopback:
                  ip:
                    - "127.0.0.0/8"
                    - "::1/128"
                    - "::FFFF:127.0.0.1/128"

              ###'  SHAPER RULES
              shaper_rules:
                ## Maximum number of simultaneous sessions allowed for a single user:
                max_user_sessions: 10
                ## Maximum number of offline messages that users can have:
                max_user_offline_messages:
                  - 5000: admin
                  - 1024
                ## For C2S connections, all users except admins use the "normal" shaper
                c2s_shaper:
                  - none: admin
                  - normal
                ## All S2S connections use the "fast" shaper
                s2s_shaper: fast

              ###'  ACCESS RULES
              access_rules:
                ## This rule allows access only for local users:
                local:
                  - allow: local
                ## Only non-blocked users can use c2s connections:
                c2s:
                  - deny: blocked
                  - allow
                ## Only admins can send announcement messages:
                announce:
                  - allow: admin
                ## Only admins can use the configuration interface:
                configure:
                  - allow: admin
                ## Only accounts of the local ejabberd server can create rooms:
                muc_create:
                  - allow: local
                ## Only accounts on the local ejabberd server can create Pubsub nodes:
                pubsub_createnode:
                  - allow: local
                ## In-band registration allows registration of any possible username.
                ## To disable in-band registration, replace 'allow' with 'deny'.
                register:
                  - allow
                ## Only allow to register from localhost
                trusted_network:
                  - allow: loopback

              ## ===============
              ## API PERMISSIONS
              ## ===============
              ##
              ## This section allows you to define who and using what method
              ## can execute commands offered by ejabberd.
              ##
              ## By default "console commands" section allow executing all commands
              ## issued using ejabberdctl command, and "admin access" section allows
              ## users in admin acl that connect from 127.0.0.1 to  execute all
              ## commands except start and stop with any available access method
              ## (ejabberdctl, http-api, xmlrpc depending what is enabled on server).
              ##
              ## If you remove "console commands" there will be one added by
              ## default allowing executing all commands, but if you just change
              ## permissions in it, version from config file will be used instead
              ## of default one.
              ##
              api_permissions:
                "console commands":
                  from:
                    - ejabberd_ctl
                  who: all
                  what: "*"

              language: "en"

              ###'  MODULES
              ## Modules enabled in all ejabberd virtual hosts.
              modules:
                mod_adhoc: {}
                mod_announce: # recommends mod_adhoc
                  access: announce
                mod_blocking: {} # requires mod_privacy
                mod_caps: {}
                mod_carboncopy: {}
                mod_client_state: {}
                mod_configure: {} # requires mod_adhoc
                ## mod_delegation: {} # for xep0356
                mod_disco: {}
                #mod_irc:
                #  host: "irc.@HOST@"
                #  default_encoding: "utf-8"
                ## mod_bosh: {}
                ## mod_http_fileserver:
                ##   docroot: "/var/www"
                ##   accesslog: "/var/log/ejabberd/access.log"
                mod_http_upload:
                  thumbnail: false # otherwise needs the identify command from ImageMagick installed
                  put_url: "http://@HOST@:5444/upload"
                ##   # docroot: "@HOME@/upload"
                #mod_http_upload_quota:
                #  max_days: 14
                mod_last: {}
                ## XEP-0313: Message Archive Management
                ## You might want to setup a SQL backend for MAM because the mnesia database is
                ## limited to 2GB which might be exceeded on large servers
                mod_mam: {}
                mod_muc:
                  host: "muc.@HOST@"
                  access:
                    - allow
                  access_admin:
                    - allow: admin
                  access_create: muc_create
                  access_persistent: muc_create
                mod_muc_admin: {}
                mod_muc_log: {}
                mod_offline:
                  access_max_user_messages: max_user_offline_messages
                mod_ping: {}
                ## mod_pres_counter:
                ##   count: 5
                ##   interval: 60
                mod_privacy: {}
                mod_private: {}
                mod_roster:
                    versioning: true
                mod_shared_roster: {}
                mod_stats: {}
                mod_time: {}
                mod_vcard:
                  search: false
                mod_vcard_xupdate: {}
                ## Convert all avatars posted by Android clients from WebP to JPEG
                mod_avatar: {}
                #  convert:
                #    webp: jpeg
                mod_version: {}
                mod_stream_mgmt: {}
                ##   The module for S2S dialback (XEP-0220). Please note that you cannot
                ##   rely solely on dialback if you want to federate with other servers,
                ##   because a lot of servers have dialback disabled and instead rely on
                ##   PKIX authentication. Make sure you have proper certificates installed
                ##   and check your accessibility at https://check.messaging.one/
                mod_s2s_dialback: {}
                mod_pubsub:
                  plugins:
                    - "pep"
                mod_push: {}
            '';
          };

          networking.firewall.enable = false;
        };
    };

    testScript =
      { nodes, ... }:
      ''
        ejabberd_prefix = "su ejabberd -s $(which ejabberdctl) "

        server.wait_for_unit("ejabberd.service")

        assert "status: started" in server.succeed(ejabberd_prefix + "status")

        server.succeed(
            ejabberd_prefix + "register azurediamond example.com hunter2",
            ejabberd_prefix + "register cthon98 example.com nothunter2",
        )
        server.fail(ejabberd_prefix + "register asdf wrong.domain")
        client.succeed("send-message")
        server.succeed(
            ejabberd_prefix + "unregister cthon98 example.com",
            ejabberd_prefix + "unregister azurediamond example.com",
        )
      '';
  }
)
