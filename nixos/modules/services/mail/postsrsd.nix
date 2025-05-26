{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.postsrsd;
  runtimeDirectoryName = "postsrsd";
  runtimeDirectory = "/run/${runtimeDirectoryName}";
  # TODO: follow RFC 42, but we need a libconfuse format first:
  #       https://github.com/NixOS/nixpkgs/issues/401565
  # Arrays in `libconfuse` look like this: {"Life", "Universe", "Everything"}
  # See https://www.nongnu.org/confuse/tutorial-html/ar01s03.html.
  #
  # Note: We're using `builtins.toJSON` to escape strings, but JSON strings
  # don't have exactly the same semantics as libconfuse strings. For example,
  # "${F}" gets treated as an env var reference, see above issue for details.
  libconfuseDomains = "{ " + lib.concatMapStringsSep ", " builtins.toJSON cfg.domains + " }";
  configFile = pkgs.writeText "postsrsd.conf" ''
    secrets-file = "''${CREDENTIALS_DIRECTORY}/secrets-file"
    domains = ${libconfuseDomains}
    separator = "${cfg.separator}"
    socketmap = "unix:${cfg.socketPath}"

    # Disable postsrsd's jailing in favor of confinement with systemd.
    unprivileged-user = ""
    chroot-dir = ""
  '';

in
{
  imports =
    map
      (
        name:
        lib.mkRemovedOptionModule [ "services" "postsrsd" name ] ''
          `postsrsd` was upgraded to `>= 2.0.0`, with some different behaviors and configuration settings:
            - NixOS Release Notes: https://nixos.org/manual/nixos/unstable/release-notes#sec-nixpkgs-release-25.05-incompatibilities
            - NixOS Options Reference: https://nixos.org/manual/nixos/unstable/options#opt-services.postsrsd.enable
            - Migration instructions: https://github.com/roehling/postsrsd/blob/2.0.10/README.rst#migrating-from-version-1x
            - Postfix Setup: https://github.com/roehling/postsrsd/blob/2.0.10/README.rst#postfix-setup
        ''
      )
      [
        "domain"
        "forwardPort"
        "reversePort"
        "timeout"
        "excludeDomains"
      ];

  options = {
    services.postsrsd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the postsrsd SRS server for Postfix.";
      };

      secretsFile = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/postsrsd/postsrsd.secret";
        description = "Secret keys used for signing and verification";
      };

      domains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Domain names for rewrite";
        default = [ config.networking.hostName ];
        defaultText = lib.literalExpression "[ config.networking.hostName ]";
      };

      separator = lib.mkOption {
        type = lib.types.enum [
          "-"
          "="
          "+"
        ];
        default = "=";
        description = "First separator character in generated addresses";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "postsrsd";
        description = "User for the daemon";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "postsrsd";
        description = "Group for the daemon";
      };

      socketPath = lib.mkOption {
        type = lib.types.path;
        default = "${runtimeDirectory}/socket";
        readOnly = true;
        description = ''
          Path to the Unix socket for connecting to postsrsd.
          Read-only, intended for usage when integrating postsrsd into other NixOS config.'';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.optionalAttrs (cfg.user == "postsrsd") {
      postsrsd = {
        group = cfg.group;
        uid = config.ids.uids.postsrsd;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "postsrsd") {
      postsrsd.gid = config.ids.gids.postsrsd;
    };

    systemd.services.postsrsd-generate-secrets = {
      path = [ pkgs.coreutils ];
      script = ''
        if [ -e "${cfg.secretsFile}" ]; then
          echo "Secrets file exists. Nothing to do!"
        else
          echo "WARNING: secrets file not found, autogenerating!"
          DIR="$(dirname "${cfg.secretsFile}")"
          install -m 750 -o ${cfg.user} -g ${cfg.group} -d "$DIR"
          install -m 600 -o ${cfg.user} -g ${cfg.group} <(dd if=/dev/random bs=18 count=1 | base64) "${cfg.secretsFile}"
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    systemd.services.postsrsd = {
      description = "PostSRSd SRS rewriting server";
      after = [
        "network.target"
        "postsrsd-generate-secrets.service"
      ];
      before = [ "postfix.service" ];
      wantedBy = [ "multi-user.target" ];
      requires = [ "postsrsd-generate-secrets.service" ];
      confinement.enable = true;

      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.postsrsd} -C ${configFile}";
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
        RuntimeDirectory = runtimeDirectoryName;
        LoadCredential = "secrets-file:${cfg.secretsFile}";
      };
    };
  };
}
