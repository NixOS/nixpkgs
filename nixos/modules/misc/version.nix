{ config, lib, options, pkgs, ... }:

let
  cfg = config.system.nixos;
  opt = options.system.nixos;

  inherit (lib)
    concatStringsSep mapAttrsToList toLower
    literalExpression mkRenamedOptionModule mkDefault mkOption trivial types;

  needsEscaping = s: null != builtins.match "[a-zA-Z0-9]+" s;
  escapeIfNecessary = s: if needsEscaping s then s else ''"${lib.escape [ "\$" "\"" "\\" "\`" ] s}"'';
  attrsToText = attrs:
    concatStringsSep "\n" (
      mapAttrsToList (n: v: ''${n}=${escapeIfNecessary (toString v)}'') attrs
    ) + "\n";

  osReleaseContents = {
    NAME = "${cfg.distroName}";
    ID = "${cfg.distroId}";
    VERSION = "${cfg.release} (${cfg.codeName})";
    VERSION_CODENAME = toLower cfg.codeName;
    VERSION_ID = cfg.release;
    BUILD_ID = cfg.version;
    PRETTY_NAME = "${cfg.distroName} ${cfg.release} (${cfg.codeName})";
    LOGO = "nix-snowflake";
    HOME_URL = lib.optionalString (cfg.distroId == "nixos") "https://nixos.org/";
    DOCUMENTATION_URL = lib.optionalString (cfg.distroId == "nixos") "https://nixos.org/learn.html";
    SUPPORT_URL = lib.optionalString (cfg.distroId == "nixos") "https://nixos.org/community.html";
    BUG_REPORT_URL = lib.optionalString (cfg.distroId == "nixos") "https://github.com/NixOS/nixpkgs/issues";
    IMAGE_ID = lib.optionalString (config.system.image.id != null) config.system.image.id;
    IMAGE_VERSION = lib.optionalString (config.system.image.version != null) config.system.image.version;
  } // lib.optionalAttrs (cfg.variant_id != null) {
    VARIANT_ID = cfg.variant_id;
  };

  initrdReleaseContents = (removeAttrs osReleaseContents [ "BUILD_ID" ]) // {
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

    nixos.distroId = mkOption {
      internal = true;
      type = types.str;
      default = "nixos";
      description = lib.mdDoc "The id of the operating system";
    };

    nixos.distroName = mkOption {
      internal = true;
      type = types.str;
      default = "NixOS";
      description = lib.mdDoc "The name of the operating system";
    };

    nixos.variant_id = mkOption {
      type = types.nullOr (types.strMatching "^[a-z0-9._-]+$");
      default = null;
      description = lib.mdDoc "A lower-case string identifying a specific variant or edition of the operating system";
      example = "installer";
    };

    image = {

      id = lib.mkOption {
        type = types.nullOr (types.strMatching "^[a-z0-9._-]+$");
        default = null;
        description = lib.mdDoc ''
          Image identifier.

          This corresponds to the IMAGE_ID field in os-release. See the
          upstream docs for more details on valid characters for this field:
          https://www.freedesktop.org/software/systemd/man/latest/os-release.html#IMAGE_ID=

          You would only want to set this option if you're build NixOS appliance images.
        '';
      };

      version = lib.mkOption {
        type = types.nullOr (types.strMatching "^[a-z0-9._-]+$");
        default = null;
        description = lib.mdDoc ''
          Image version.

          This corresponds to the IMAGE_VERSION field in os-release. See the
          upstream docs for more details on valid characters for this field:
          https://www.freedesktop.org/software/systemd/man/latest/os-release.html#IMAGE_VERSION=

          You would only want to set this option if you're build NixOS appliance images.
        '';
      };

    };

    stateVersion = mkOption {
      type = types.str;
      # TODO Remove this and drop the default of the option so people are forced to set it.
      # Doing this also means fixing the comment in nixos/modules/testing/test-instrumentation.nix
      apply = v:
        lib.warnIf (options.system.stateVersion.highestPrio == (lib.mkOptionDefault { }).priority)
          "system.stateVersion is not set, defaulting to ${v}. Read why this matters on https://nixos.org/manual/nixos/stable/options.html#opt-system.stateVersion."
          v;
      default = cfg.release;
      defaultText = literalExpression "config.${opt.release}";
      description = lib.mdDoc ''
        This option defines the first version of NixOS you have installed on this particular machine,
        and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.

        For example, if NixOS version XX.YY ships with AwesomeDB version N by default, and is then
        upgraded to version XX.YY+1, which ships AwesomeDB version N+1, the existing databases
        may no longer be compatible, causing applications to fail, or even leading to data loss.

        The `stateVersion` mechanism avoids this situation by making the default version of such packages
        conditional on the first version of NixOS you've installed (encoded in `stateVersion`), instead of
        simply always using the latest one.

        Note that this generally only affects applications that can't upgrade their data automatically -
        applications and services supporting automatic migrations will remain on latest versions when
        you upgrade.

        Most users should **never** change this value after the initial install, for any reason,
        even if you've upgraded your system to a new NixOS release.

        This value does **not** affect the Nixpkgs version your packages and OS are pulled from,
        so changing it will **not** upgrade your system.

        This value being lower than the current NixOS release does **not** mean your system is
        out of date, out of support, or vulnerable.

        Do **not** change this value unless you have manually inspected all the changes it would
        make to your configuration, and migrated your data accordingly.
      '';
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
        DISTRIB_ID = "${cfg.distroId}";
        DISTRIB_RELEASE = cfg.release;
        DISTRIB_CODENAME = toLower cfg.codeName;
        DISTRIB_DESCRIPTION = "${cfg.distroName} ${cfg.release} (${cfg.codeName})";
      };

      "os-release".text = attrsToText osReleaseContents;
    };

  };

  # uses version info nixpkgs, which requires a full nixpkgs path
  meta.buildDocsInSandbox = false;
}
