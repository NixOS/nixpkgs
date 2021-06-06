{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.sourcehut;
  cfgIni = cfg.settings;
  settingsFormat = pkgs.formats.ini { };

  # Specialized python containing all the modules
  python = pkgs.sourcehut.python.withPackages (ps: with ps; [
    gunicorn
    # Sourcehut services
    srht
    buildsrht
    dispatchsrht
    gitsrht
    hgsrht
    hubsrht
    listssrht
    mansrht
    metasrht
    pastesrht
    todosrht
  ]);
in
{
  imports =
    [
      ./git.nix
      ./hg.nix
      ./hub.nix
      ./todo.nix
      ./man.nix
      ./meta.nix
      ./paste.nix
      ./builds.nix
      ./lists.nix
      ./dispatch.nix
      (mkRemovedOptionModule [ "services" "sourcehut" "nginx" "enable" ] ''
        The sourcehut module supports `nginx` as a local reverse-proxy by default and doesn't
        support other reverse-proxies officially.

        However it's possible to use an alternative reverse-proxy by

          * disabling nginx
          * adjusting the relevant settings for server addresses and ports directly

        Further details about this can be found in the `Sourcehut`-section of the NixOS-manual.
      '')
    ];

  options.services.sourcehut = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable sourcehut - git hosting, continuous integration, mailing list, ticket tracking,
        task dispatching, wiki and account management services
      '';
    };

    services = mkOption {
      type = types.nonEmptyListOf (types.enum [ "builds" "dispatch" "git" "hub" "hg" "lists" "man" "meta" "paste" "todo" ]);
      default = [ "man" "meta" "paste" ];
      example = [ "builds" "dispatch" "git" "hub" "hg" "lists" "man" "meta" "paste" "todo" ];
      description = ''
        Services to enable on the sourcehut network.
      '';
    };

    originBase = mkOption {
      type = types.str;
      default = with config.networking; hostName + lib.optionalString (domain != null) ".${domain}";
      description = ''
        Host name used by reverse-proxy and for default settings. Will host services at git."''${originBase}". For example: git.sr.ht
      '';
    };

    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        Address to bind to.
      '';
    };

    python = mkOption {
      internal = true;
      type = types.package;
      default = python;
      description = ''
        The python package to use. It should contain references to the *srht modules and also
        gunicorn.
      '';
    };

    statePath = mkOption {
      type = types.path;
      default = "/var/lib/sourcehut";
      description = ''
        Root state path for the sourcehut network. If left as the default value
        this directory will automatically be created before the sourcehut server
        starts, otherwise the sysadmin is responsible for ensuring the
        directory exists with appropriate ownership and permissions.
      '';
    };

    settings = mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
      description = ''
        The configuration for the sourcehut network.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions =
      [
        {
          assertion = with cfgIni.webhooks; private-key != null && stringLength private-key == 44;
          message = "The webhook's private key must be defined and of a 44 byte length.";
        }

        {
          assertion = hasAttrByPath [ "meta.sr.ht" "origin" ] cfgIni && cfgIni."meta.sr.ht".origin != null;
          message = "meta.sr.ht's origin must be defined.";
        }
      ];

    virtualisation.docker.enable = true;
    environment.etc."sr.ht/config.ini".source =
      settingsFormat.generate "sourcehut-config.ini" (mapAttrsRecursive
        (
          path: v: if v == null then "" else v
        )
        cfg.settings);

    environment.systemPackages = [ pkgs.sourcehut.coresrht ];

    # PostgreSQL server
    services.postgresql.enable = mkOverride 999 true;
    # Mail server
    services.postfix.enable = mkOverride 999 true;
    # Cron daemon
    services.cron.enable = mkOverride 999 true;
    # Redis server
    services.redis.enable = mkOverride 999 true;
    services.redis.bind = mkOverride 999 "127.0.0.1";

    services.sourcehut.settings = {
      # The name of your network of sr.ht-based sites
      "sr.ht".site-name = mkDefault "sourcehut";
      # The top-level info page for your site
      "sr.ht".site-info = mkDefault "https://sourcehut.org";
      # {{ site-name }}, {{ site-blurb }}
      "sr.ht".site-blurb = mkDefault "the hacker's forge";
      # If this != production, we add a banner to each page
      "sr.ht".environment = mkDefault "development";
      # Contact information for the site owners
      "sr.ht".owner-name = mkDefault "Drew DeVault";
      "sr.ht".owner-email = mkDefault "sir@cmpwn.com";
      # The source code for your fork of sr.ht
      "sr.ht".source-url = mkDefault "https://git.sr.ht/~sircmpwn/srht";
      # A secret key to encrypt session cookies with
      "sr.ht".secret-key = mkDefault null;
      "sr.ht".global-domain = mkDefault null;

      # Outgoing SMTP settings
      mail.smtp-host = mkDefault null;
      mail.smtp-port = mkDefault null;
      mail.smtp-user = mkDefault null;
      mail.smtp-password = mkDefault null;
      mail.smtp-from = mkDefault null;
      # Application exceptions are emailed to this address
      mail.error-to = mkDefault null;
      mail.error-from = mkDefault null;
      # Your PGP key information (DO NOT mix up pub and priv here)
      # You must remove the password from your secret key, if present.
      # You can do this with gpg --edit-key [key-id], then use the passwd
      # command and do not enter a new password.
      mail.pgp-privkey = mkDefault null;
      mail.pgp-pubkey = mkDefault null;
      mail.pgp-key-id = mkDefault null;

      # base64-encoded Ed25519 key for signing webhook payloads. This should be
      # consistent for all *.sr.ht sites, as we'll use this key to verify signatures
      # from other sites in your network.
      #
      # Use the srht-webhook-keygen command to generate a key.
      webhooks.private-key = mkDefault null;
    };
  };
  meta.doc = ./sourcehut.xml;
  meta.maintainers = with maintainers; [ tomberek ];
}
