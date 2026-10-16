# User/group identity for modular services.
# See https://github.com/NixOS/nixpkgs/issues/545287
#
# This module declares the portable *request* options. The values set here are
# requests: the service manager resolves them to the real values by re-declaring
# these options with `apply` functions, so that reading the option values yields
# the identity that the service will actually run as, or `null` on platforms
# that do not support users.
#
# A service module may set these options portably; on a service manager that
# does not use them, the values remain as they were set.
{ lib, ... }:
let
  inherit (lib) mkOption types;

  /**
    The type of a reference to a modular service, used for
    `identity.sameUser`.

    Any modular service configuration is a valid value: the built-in
    `absoluteServicePath` option serves as the tag that identifies it as one.
    This is the same idiom as nixops4's resource reference type, which checks
    for its `absoluteMemberPath` option.
  */
  modularService = lib.mkOptionType {
    name = "modular-service";
    description = "modular service reference";
    descriptionClass = "noun";
    check = value: value ? absoluteServicePath;
    merge = lib.mergeUniqueOption {
      message = "A modular service reference cannot be merged.";
    };
  };
in
{
  options.identity = mkOption {
    description = ''
      User and group identity for this service.

      The option values in this option tree are *requests*. The service manager
      implementation resolves them to the real values, so that reading the
      values yields the identity that the service will actually run as, or
      `null` on platforms that do not support users.

      By default, on platforms that support users, each service runs as its own
      user, whose name is derived from the service's attribute path, with
      uid/gid allocated by the platform.
    '';
    type = types.submodule {
      options = {
        user = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            The user account to run this service as.

            If `null`, the service manager derives a user name from the
            service's attribute path, unless {option}`identity.sameUser`
            is set.
          '';
        };

        uid = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = ''
            The numeric uid for the service user.

            If `null`, the uid is allocated by the platform; e.g. NixOS picks
            a free uid on activation.
          '';
        };

        group = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            The primary group to run this service as.

            If `null`, the service manager derives it from the user, typically
            as a user-private group named after the user, unless
            {option}`identity.sameUser` is set.
          '';
        };

        gid = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = ''
            The numeric gid for the service's primary group.

            If `null`, the gid is allocated by the platform; e.g. NixOS picks
            a free gid on activation.
          '';
        };

        groups = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = null;
          description = ''
            Supplementary groups for the service user.

            When {option}`identity.gids` is also set, the two lists are
            paired positionally: the i-th gid is the gid of the i-th group.
          '';
        };

        gids = mkOption {
          type = types.nullOr (types.listOf types.int);
          default = null;
          description = ''
            Numeric gids for the supplementary groups in
            {option}`identity.groups`, paired positionally.

            Must be empty or have the same length as
            {option}`identity.groups`.
          '';
        };

        sameUser = mkOption {
          type = types.nullOr modularService;
          default = null;
          description = ''
            Run this service as the same user and group as another modular
            service: the referenced service's resolved identity (user, uid,
            group, gid, groups, gids) is used for this service.

            The value is the other service's configuration. Pass it with
            `config`:

            ```nix
            services.bar = {
              imports = [ ./bar.nix ];
              identity.sameUser = config.services.foo;
            };
            ```

            Options set on this service take precedence over the reference. The
            referenced service's `sameUser` must not, transitively, reference this service,
            because that would be infinite recursion.
          '';
        };
      };
    };
    default = { };
  };
}
