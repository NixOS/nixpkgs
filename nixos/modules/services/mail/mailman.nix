{ config, pkgs, lib, ... }:          # mailman.nix

with lib;

let

  cfg = config.services.mailman;

  pythonEnv = pkgs.python3.withPackages (ps: [ps.mailman]);

  mailmanExe = with pkgs; stdenv.mkDerivation {
    name = "mailman-" + python3Packages.mailman.version;
    unpackPhase = ":";
    installPhase = ''
      mkdir -p $out/bin
      sed >"$out/bin/mailman" <"${pythonEnv}/bin/mailman" \
        -e "2 iexport MAILMAN_CONFIG_FILE=/etc/mailman.cfg"
      chmod +x $out/bin/mailman
    '';
  };

  mailmanCfg = ''
    [mailman]
    site_owner: ${cfg.siteOwner}
    layout: fhs

    [paths.fhs]
    bin_dir: ${pkgs.python3Packages.mailman}/bin
    var_dir: /var/lib/mailman
    queue_dir: $var_dir/queue
    log_dir: $var_dir/log
    lock_dir: $var_dir/lock
    etc_dir: /etc
    ext_dir: $etc_dir/mailman.d
    pid_file: /run/mailman/master.pid
  '';

in {

  ###### interface

  options = {

    services.mailman = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Mailman on this host. Requires an active Postfix installation.";
      };

      siteOwner = mkOption {
        type = types.str;
        default = "postmaster";
        description = ''
          Certain messages that must be delivered to a human, but which can't
          be delivered to a list owner (e.g. a bounce from a list owner), will
          be sent to this address. It should point to a human.
        '';
      };


    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.enable -> config.services.postfix.enable;
        message = "Mailman requires Postfix";
      }
      { assertion = config.services.postfix.recipientDelimiter == "+";
        message = "Postfix's recipientDelimiter must be set to '+'.";
      }
    ];

    users.users.mailman = { description = "GNU Mailman"; isSystemUser = true; };

    environment = {
      systemPackages = [ mailmanExe ];
      etc."mailman.cfg".text = mailmanCfg;
    };

    services.postfix = {
      relayDomains = [ "hash:/var/lib/mailman/data/postfix_domains" ];
      config = {
        transport_maps = [ "hash:/var/lib/mailman/data/postfix_lmtp" ];
        local_recipient_maps = [ "hash:/var/lib/mailman/data/postfix_lmtp" ];
        # Mailman uses recipient delimiters, so we don't need special handling.
        owner_request_special = "no";
      };
    };

    systemd.services.mailman = {
      description = "GNU Mailman Master Process";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${mailmanExe}/bin/mailman start";
        ExecStop = "${mailmanExe}/bin/mailman stop";
        User = "mailman";
        Type = "forking";
        StateDirectory = "mailman";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "mailman";
        PIDFile = "/run/mailman/master.pid";
      };
    };

  };

}
