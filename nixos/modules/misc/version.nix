{ config, lib, options, pkgs, ... }:

let
  cfg = config.system.nixos;
  opt = options.system.nixos;

  inherit (lib)
    concatStringsSep mapAttrsToList toLower
    literalExpression mkRenamedOptionModule mkDefault mkOption trivial types;

  needsEscaping = s: null != builtins.match "[a-zA-Z0-9]+" s;
  escapeIfNeccessary = s: if needsEscaping s then s else ''"${lib.escape [ "\$" "\"" "\\" "\`" ] s}"'';
  attrsToText = attrs:
    concatStringsSep "\n" (
      mapAttrsToList (n: v: ''${n}=${escapeIfNeccessary (toString v)}'') attrs
    ) + "\n";

  osReleaseContents = {
    NAME = "NixOS";
    ID = "nixos";
    VERSION = "${cfg.release} (${cfg.codeName})";
    VERSION_CODENAME = toLower cfg.codeName;
    VERSION_ID = cfg.release;
    BUILD_ID = cfg.version;
    PRETTY_NAME = "NixOS ${cfg.release} (${cfg.codeName})";
    LOGO = "nix-snowflake";
    HOME_URL = "https://nixos.org/";
    DOCUMENTATION_URL = "https://nixos.org/learn.html";
    SUPPORT_URL = "https://nixos.org/community.html";
    BUG_REPORT_URL = "https://github.com/NixOS/nixpkgs/issues";
  };

  initrdReleaseContents = osReleaseContents // {
    PRETTY_NAME = "${osReleaseContents.PRETTY_NAME} (Initrd)";
  };
  initrdRelease = pkgs.writeText "initrd-release" (attrsToText initrdReleaseContents);

in
{
  imports = [
    ./label.nix
    (mkRenamedOptionModule [ "system" "nixosVersion" ] [ "system" "nixos" "version" ])
    (mkRenamedOptionModule [ "system" "nixosVersionSuffix" ] [ "system" "nixos" "versionSuffix" ])
    (mkRenamedOptionModule [ "system" "nixosRevision" ] [ "system" "nixos" "revision" ])
    (mkRenamedOptionModule [ "system" "nixosLabel" ] [ "system" "nixos" "label" ])
  ];

  options.boot.initrd.osRelease = mkOption {
    internal = true;
    readOnly = true;
    default = initrdRelease;
  };

  options.system = {

    nixos.version = mkOption {
      internal = true;
      type = types.str;
      description = lib.mdDoc "The full NixOS version (e.g. `16.03.1160.f2d4ee1`).";
    };

    nixos.release = mkOption {
      readOnly = true;
      type = types.str;
      default = trivial.release;
      description = lib.mdDoc "The NixOS release (e.g. `16.03`).";
    };

    nixos.versionSuffix = mkOption {
      internal = true;
      type = types.str;
      default = trivial.versionSuffix;
      description = lib.mdDoc "The NixOS version suffix (e.g. `1160.f2d4ee1`).";
    };

    nixos.revision = mkOption {
      internal = true;
      type = types.nullOr types.str;
      default = trivial.revisionWithDefault null;
      description = lib.mdDoc "The Git revision from which this NixOS configuration was built.";
    };

    nixos.codeName = mkOption {
      readOnly = true;
      type = types.str;
      default = trivial.codeName;
      description = lib.mdDoc "The NixOS release code name (e.g. `Emu`).";
    };

    stateVersion = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        Every once in a while, a new NixOS release may change
        configuration defaults in a way incompatible with stateful
        data. For instance, if the default version of PostgreSQL
        changes, the new version will probably be unable to read your
        existing databases. To prevent such breakage, you should set the
        value of this option to the NixOS release with which you want
        to be compatible. The effect is that NixOS will use
        defaults corresponding to the specified release (such as using
        an older version of PostgreSQL).
        It‘s perfectly fine and recommended to leave this value at the
        release version of the first install of this system.
        Changing this option will not upgrade your system. In fact it
        is meant to stay constant exactly when you upgrade your system.
        You should only bump this option, if you are sure that you can
        or have migrated all state on your system which is affected
        by this option.
      '';
    };

    defaultChannel = mkOption {
      internal = true;
      type = types.str;
      default = "https://nixos.org/channels/nixos-unstable";
      description = lib.mdDoc "Default NixOS channel to which the root user is subscribed.";
    };

    configurationRevision = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc "The Git revision of the top-level flake from which this configuration was built.";
    };

  };

  config = {

    system.nixos = {
      # These defaults are set here rather than up there so that
      # changing them would not rebuild the manual
      version = mkDefault (cfg.release + cfg.versionSuffix);
    };

    # Generate /etc/os-release.  See
    # https://www.freedesktop.org/software/systemd/man/os-release.html for the
    # format.
    environment.etc = {
      "lsb-release".text = attrsToText {
        LSB_VERSION = "${cfg.release} (${cfg.codeName})";
        DISTRIB_ID = "nixos";
        DISTRIB_RELEASE = cfg.release;
        DISTRIB_CODENAME = toLower cfg.codeName;
        DISTRIB_DESCRIPTION = "NixOS ${cfg.release} (${cfg.codeName})";
      };

      "os-release".text = attrsToText osReleaseContents;
    };
  };

  # uses version info nixpkgs, which requires a full nixpkgs path
  meta.buildDocsInSandbox = false;
}
