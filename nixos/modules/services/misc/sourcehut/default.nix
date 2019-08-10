{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.sourcehut;
  cfgIni = cfg.settings;

  # Specialized python containing all the modules
  python = pkgs.sourcehut.python.withPackages (ps: with ps; [
    gunicorn
    # Sourcehut services
    buildsrht dispatchsrht gitsrht hgsrht listssrht mansrht
    metasrht pastesrht todosrht
  ]);
in {
  imports =
    [
      ./git.nix
      ./hg.nix
      ./todo.nix
      ./meta.nix
      ./paste.nix
    ];

  options.services.sourcehut = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable sourcehut - git hosting, continuous integration, mailing list, ticket tracking,
        task dispatching, wiki and account management services.
      '';
    };

    services = mkOption {
      type = types.nonEmptyListOf (types.enum [ "builds" "dispatch" "git" "hg" "lists" "man" "meta" "paste" "todo" ]);
      default = [ "builds" "dispatch" "git" "hg" "lists" "man" "meta" "paste" "todo" ];
      description = ''
        Services to enable on the sourcehut network.
      '';
    };

    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
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
      default = "/var/sourcehut";
      description = ''
        Root state path for the sourcehut network.
      '';
    };

    settings = mkOption {
      type = with types; attrsOf (attrsOf (nullOr (either bool (either int (either float (either str path))))));
      default = {};
      description = ''
        The configuration for the sourcehut network.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions =
      [
        { assertion = with cfgIni."sr.ht"; secret-key != null && stringLength secret-key == 32;
          message = "sr.ht's secret key must be defined and of a 32 byte length."; }

        # Is it always 44 characters...? At least from the times I've generated one...
        { assertion = with cfgIni.webhooks; private-key != null && stringLength private-key == 44;
          message = "The webhook's private key must be defined."; }

        { assertion = hasAttrByPath [ "meta.sr.ht" "origin" ] cfgIni && cfgIni."meta.sr.ht".origin != null;
          message = "meta.sr.ht's origin must be defined."; }
      ];

    environment.etc."sr.ht/config.ini".text = let
      mkKeyValue = key: v: let
        isPath = v: builtins.typeOf v == "path";

        value =
          if null == v        then ""
          else if true == v   then "yes"
          else if false == v  then "no"
          else if isInt v     then toString v
          else if isString v  then toString v
          else if isPath v    then toString v
          else abort "sourcehut.mkKeyValue: unexpected type (v = ${v})";
      in "${toString key}=${value}";
    in generators.toINI { inherit mkKeyValue; } cfg.settings;

    environment.systemPackages = [ python ];

    # PostgreSQL server
    services.postgresql.enable = true;
    # Mail server
    services.postfix.enable = mkOverride 999 true;
    # Cron daemon
    services.cron.enable = mkOverride 999 true;
    # Redis server
    services.redis = {
      enable = true;
      port = mkDefault 6379;
      # TODO: localhost
      bind = mkDefault "127.0.0.1";
      # TODO: More like 2?
      databases = mkDefault 8;
    };

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
}
