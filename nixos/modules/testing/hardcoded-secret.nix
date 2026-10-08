{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.testing.hardcoded-secret;
  opt = options.testing.hardcoded-secret;

  inherit (lib) mkOption;
  inherit (lib.types) str;
  inherit (pkgs) writeText;
in
{
  options.testing.hardcoded-secret = {
    directory = mkOption {
      type = str;
      default = "/run/hardcodedsecrets";
      description = ''
        Directory in which the provider writes the secret files.
        The path of each secret file in this directory is the path of its entry in
        [](#opt-testing.hardcoded-secret.fileSecrets), for example `stash/passwordFile`.
      '';
    };

    fileSecrets = mkOption {
      default = { };
      description = ''
        Hardcoded file secrets. These should only be used in tests.

        They aim to replace the usage of pkgs.writeText in NixOS VM tests
        as those make the file world readable
        while this module set runtime permissions on the file.
        This makes the tests more accurate, ensuring the permissions
        set by the contract consumer are correct.

        For each entry, a service writes `providerOptions.content` to `response.path`,
        with the `mode`, `owner` and `group` from `request`.
        The service runs after `systemd-sysusers` or `userborn`, and before `sysinit.target`,
        thus the file exists before the services that use it start.
        The content is also in the Nix store, where each user can read it.
      '';
      example = lib.literalExpression ''
        {
          myService.mySecret = {
            request = {
              owner = "me";
              group = "me";
              mode = "0400";
            };
            providerOptions.content = "My Secret";
          };
        }
      '';
      type = lib.contracts.fileSecrets.mkProviderType {
        overrides.request = {
          owner.default = "root";
          group.default = "root";
        };
        providerOptions.content = mkOption {
          type = str;
          description = ''
            Content of the secret as a string.

            This will be stored in the nix store and should only be used for testing or maybe in dev.
          '';
        };
        # The path of the entry in `fileSecrets`, for example `stash/passwordFile`.
        fulfill' =
          { loc, ... }:
          {
            path = "${cfg.directory}/${lib.concatStringsSep "/" (lib.drop (lib.length opt.fileSecrets.loc) loc)}";
          };
      };
    };
  };

  config = {
    # Fulfill the requests that the contracts system sends to this provider.
    testing.hardcoded-secret.fileSecrets =
      config.contracts.fileSecrets.providerRequests.hardcoded-secret;
    contracts.fileSecrets.providers.hardcoded-secret.module = options.testing.hardcoded-secret;

    # Write each secret in a service and not in an activation script.
    # An activation script can run before the owner of the secret exists:
    # activation scripts without dependencies run in alphabetical order,
    # and `systemd-sysusers` and `userborn` create users after activation.
    # The services run before `sysinit.target`, thus before all services
    # that have default dependencies, such as the consumers of the secrets.
    systemd.services = lib.concatMapNestedAttrs' opt.fileSecrets.type (
      path: cfg':
      let
        n = lib.concatStringsSep "_" path;
        source = writeText "hardcodedsecret_${n}_content" cfg'.providerOptions.content;

        inherit (cfg') request response;
      in
      {
        "hardcodedsecret_${n}" = {
          description = "Hardcoded secret ${lib.showAttrPath path}";
          wantedBy = [ "sysinit.target" ];
          after = [
            "local-fs.target"
            "systemd-sysusers.service"
            "userborn.service"
          ];
          before = [
            "sysinit.target"
            "shutdown.target"
          ];
          conflicts = [ "shutdown.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            install -D -m ${request.mode} -o ${request.owner} -g ${request.group} \
              ${source} "${response.path}"
          '';
        };
      }
    ) cfg.fileSecrets;
  };
}
