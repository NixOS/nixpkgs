# Tests the boundary between a modular service consumer and a NixOS-level provider.
#
# - A modular service wants to consume a fileSecrets contract, and reads
#   the result path at runtime.
# - The `hardcoded-secret` NixOS module (provider) fulfills the request at the
#   containing-system level.
# - `nixos-contracts-bridge` wires the modular service's
#   `contracts.fileSecrets.want` into NixOS `contracts.fileSecrets.want`.
# - The result path flows back into the modular service via
#   `config.contracts.fileSecrets.results`.
#
# This demonstrates contracts working across the modular-service / NixOS boundary,
# as opposed to tests focusing on just one or the other.
{ lib, pkgs, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.contracts) fileSecrets;

  secretContent = "modular-service-boundary-test-secret";

  # A minimal modular service that requests a file secret and echoes its
  # content to a known path so the test script can verify it.
  consumerModule =
    {
      lib,
      config,
      name,
      ...
    }:
    {
      _class = "service";

      options.myapp.secret = mkOption {
        default = { };
        type = fileSecrets.mkContract {
          request = {
            owner.default = "root";
            group.default = "root";
          };
        };
      };

      config = {
        contracts.fileSecrets.want = {
          inherit (config.myapp) secret;
        };

        myapp.secret.result = config.contracts.fileSecrets.results.secret;

        process.argv = [
          "${pkgs.bash}/bin/sh"
          "-c"
          "cp ${lib.escapeShellArg config.myapp.secret.result.path} /tmp/secret-check"
        ];

        systemd.service = {
          serviceConfig.Type = "oneshot";
          serviceConfig.RemainAfterExit = true;
          serviceConfig.Restart = lib.mkForce "no";
        };
      };
    };
in
{
  name = "contracts-nixos-provider-modular-consumer";

  containers.machine =
    { config, ... }:
    {
      imports = [
        ../../modules/testing/hardcoded-secret.nix
      ];

      # Consumer: a modular service that requests a fileSecret.
      system.services.instance = {
        imports = [ consumerModule ];
      };

      # Provider: NixOS-level hardcoded-secret module fulfills the request.
      contracts.fileSecrets.defaultProviderName = "hardcoded-secret";
      testing.hardcoded-secret.fileSecrets.instance.secret.content = secretContent;

      assertions = [
        {
          assertion =
            config.contracts.fileSecrets.results.instance.secret.path == "/run/hardcodedsecrets/secret";
          message = "fileSecrets contract: result path should be under hardcodedsecrets directory";
        }
      ];
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    # The modular service copied the secret content to /tmp/secret-check.
    content = machine.succeed("cat /tmp/secret-check").strip()
    assert content == "${secretContent}", \
        f"Expected '${secretContent}', got '{content}'"
  '';

  meta.maintainers = with lib.maintainers; [ kiara ];
}
