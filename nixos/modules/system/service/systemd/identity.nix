# Resolution of modular service identity (user/group) requests for NixOS.
# See https://github.com/NixOS/nixpkgs/issues/545287
#
# Like ./config-data-path.nix, this module is applied at every level of the
# service tree, so that the resolution can depend on the service's attribute
# path. It also injects the `absoluteServicePath` option for every service,
# which turns each service configuration into a referenceable handle
# (`identity.sameUser`); see the portable identity options.
#
# The resolution is performed with `apply` on the option declarations (see the
# option re-declarations below), so that reading `config.identity.*` yields the
# real value, or `null` on platforms that do not support users. `apply` is used
# instead of `mkForce` because forcing the same options that the resolution
# reads from would be infinite recursion.
#
# Resolution rules (with `supported = true`):
# - `user`: the requested user, else the referenced service's user, else a name
#   derived from the service's attribute path (`svc-<path>`).
# - `uid`: the requested uid, else the referenced service's uid, else `null`,
#   which makes NixOS pick a free uid on activation.
# - `group`: the requested group, else the referenced service's group, else the
#   user (user-private group).
# - `gid`: the requested gid, else the referenced service's gid, else `null`.
# - `groups`/`gids`: the requested lists, else the referenced service's, else
#   empty lists.
{ lib }:
let
  inherit (lib) mkOption types;
in
rec {
  /**
    Create the identity resolution module for one level of the service tree.

    # Inputs

    `supported`

    : 1\. Whether the platform supports user accounts. When `false`, all
    identity values resolve to `null`, regardless of the requests.

    `path`

    : 2\. The absolute service path of the containing service, as a list of
    attribute names. `[]` for the top-level service, so that `path ++ [ name ]`
    is the service's own absolute service path.

    # Output

    A module, to be loaded into a service's module set.
  */
  mkIdentityModule =
    { supported, path }:
    {
      lib,
      name,
      config,
      ...
    }:
    let
      absoluteServicePath = path ++ [ name ];

      # A user/group name derived from the service's attribute path. Names are
      # limited to 31 characters by the system user registry.
      derivedUser =
        let
          userName = "svc-" + lib.strings.concatStringsSep "-" absoluteServicePath;
        in
        if lib.stringLength userName >= 32 then
          throw "The user name `${userName}', derived from the service path `${lib.concatStringsSep "." absoluteServicePath}', is too long. User names are limited to 31 characters; set `identity.user' for this service."
        else
          userName;

      # The identity referenced via `identity.sameUser`, resolved from the
      # referenced service. `null` when not set. A service configuration is its
      # own handle: it carries the resolved identity values directly.
      refIdentity =
        # The reference affects only services that actually resolve identities.
        if config.identity.sameUser == null || !supported then null else config.identity.sameUser.identity;

      # Resolution of each request value. Every `apply` receives the requested
      # value as its argument, which is how the request is read without
      # recursing into the option being resolved.
      resolve = {
        user =
          request:
          if !supported then
            null
          else if request != null then
            request
          else if refIdentity != null then
            refIdentity.user
          else
            derivedUser;

        uid =
          request:
          if !supported then
            null
          else if request != null then
            request
          else if refIdentity != null then
            refIdentity.uid
          else
            null;

        group =
          request:
          if !supported then
            null
          else if request != null then
            request
          else if refIdentity != null then
            refIdentity.group
          else
            config.identity.user;

        gid =
          request:
          if !supported then
            null
          else if request != null then
            request
          else if refIdentity != null then
            refIdentity.gid
          else
            null;

        groups =
          request:
          if !supported then
            null
          else if request != null then
            request
          else if refIdentity != null then
            refIdentity.groups
          else
            [ ];

        gids =
          request:
          if !supported then
            null
          else if request != null then
            request
          else if refIdentity != null then
            refIdentity.gids
          else
            [ ];
      };
    in
    {
      _class = "service";
      options = {
        # The absolute service path of this service, from the top-level
        # service. This option turns each service configuration into a
        # referenceable handle for `identity.sameUser`. It is injected by this
        # module at every level of the service tree; `readOnly = true` allows
        # exactly that one definition, so other modules cannot override it.
        # Like nixops4's resource paths (`absoluteMemberPath`), the path is a
        # list of attribute names, to avoid dash ambiguity.
        absoluteServicePath = mkOption {
          type = types.listOf types.str;
          internal = true;
          readOnly = true;
        };

        # Re-declare the portable `identity` option, adding the resolution as
        # `apply`. Only `apply` may be set here: type, default and description
        # come from the portable declaration, and setting any of them again
        # would make the declarations unmergeable.
        # `types.submodule` rather than `submoduleWith`, to match the portable
        # declaration's type, so that they merge.
        identity = mkOption {
          type = types.submodule [
            {
              options = {
                user = mkOption {
                  apply = resolve.user;
                };
                uid = mkOption {
                  apply = resolve.uid;
                };
                group = mkOption {
                  apply = resolve.group;
                };
                gid = mkOption {
                  apply = resolve.gid;
                };
                groups = mkOption {
                  apply = resolve.groups;
                };
                gids = mkOption {
                  apply = resolve.gids;
                };
              };
            }
          ];
        };

        services = mkOption {
          type = types.attrsOf (
            types.submoduleWith {
              modules = [
                (mkIdentityModule {
                  inherit supported;
                  path = absoluteServicePath;
                })
              ];
            }
          );
        };
      };

      config = {
        absoluteServicePath = absoluteServicePath;

        assertions = [
          {
            assertion =
              config.identity.gids == null
              || config.identity.gids == [ ]
              || (
                config.identity.groups != null
                && lib.length config.identity.groups == lib.length config.identity.gids
              );
            message = "identity.gids must be empty or have the same length as identity.groups, because they are paired positionally.";
          }
        ];
      };
    };
}
