# Not a module
{ pkgs, lib }:
let
  inherit (lib)
    types
    literalExpression
    mkOption
    ;

  format = pkgs.formats.toml { };

  settingsModule =
    {
      config,
      packageOption,
      pkgs,
      ...
    }:
    {
      freeformType = format.type;
      options = {
        apiBaseUrl = mkOption {
          description = ''
            API base URL that the agent will connect to.

            When using Hercules CI Enterprise, set this to the URL where your
            Hercules CI server is reachable.
          '';
          type = types.str;
          default = "https://hercules-ci.com";
        };
        baseDirectory = mkOption {
          type = types.path;
          default = "/var/lib/hercules-ci-agent";
          description = ''
            State directory (secrets, work directory, etc) for agent
          '';
        };
        concurrentTasks = mkOption {
          description = ''
            Number of tasks to perform simultaneously.

            A task is a single derivation build, an evaluation or an effect run.
            At minimum, you need 2 concurrent tasks for `x86_64-linux`
            in your cluster, to allow for import from derivation.

            `concurrentTasks` can be around the CPU core count or lower if memory is
            the bottleneck.

            The optimal value depends on the resource consumption characteristics of your workload,
            including memory usage and in-task parallelism. This is typically determined empirically.

            When scaling, it is generally better to have a double-size machine than two machines,
            because each split of resources causes inefficiencies; particularly with regards
            to build latency because of extra downloads.
          '';
          type = types.either types.ints.positive (types.enum [ "auto" ]);
          default = "auto";
          defaultText = lib.literalMD ''
            `"auto"`, meaning equal to the number of CPU cores.
          '';
        };
        labels = mkOption {
          description = ''
            A key-value map of user data.

            This data will be available to organization members in the dashboard and API.

            The values can be of any TOML type that corresponds to a JSON type, but arrays
            can not contain tables/objects due to limitations of the TOML library. Values
            involving arrays of non-primitive types may not be representable currently.
          '';
          type = format.type;
          defaultText = literalExpression ''
            {
              agent.source = "..."; # One of "nixpkgs", "flake", "override"
              lib.version = "...";
              pkgs.version = "...";
            }
          '';
        };
        workDirectory = mkOption {
          description = ''
            The directory in which temporary subdirectories are created for task state. This includes sources for Nix evaluation.
          '';
          type = types.path;
          default = config.baseDirectory + "/work";
          defaultText = literalExpression ''baseDirectory + "/work"'';
        };
        staticSecretsDirectory = mkOption {
          description = ''
            This is the default directory to look for statically configured secrets like `cluster-join-token.key`.

            See also `clusterJoinTokenPath` and `binaryCachesPath` for fine-grained configuration.
          '';
          type = types.path;
          default = config.baseDirectory + "/secrets";
          defaultText = literalExpression ''baseDirectory + "/secrets"'';
        };
        clusterJoinTokenPath = mkOption {
          description = ''
            Location of the cluster-join-token.key file.

            You can retrieve the contents of the file when creating a new agent via
            <https://hercules-ci.com/dashboard>.

            As this value is confidential, it should not be in the store, but
            installed using other means, such as agenix, NixOps
            `deployment.keys`, or manual installation.

            The contents of the file are used for authentication between the agent and the API.
          '';
          type = types.path;
          default = config.staticSecretsDirectory + "/cluster-join-token.key";
          defaultText = literalExpression ''staticSecretsDirectory + "/cluster-join-token.key"'';
        };
        binaryCachesPath = mkOption {
          description = ''
            Path to a JSON file containing binary cache secret keys.

            As these values are confidential, they should not be in the store, but
            copied over using other means, such as agenix, NixOps
            `deployment.keys`, or manual installation.

            The format is described on <https://docs.hercules-ci.com/hercules-ci-agent/binary-caches-json/>.
          '';
          type = types.path;
          default = config.staticSecretsDirectory + "/binary-caches.json";
          defaultText = literalExpression ''staticSecretsDirectory + "/binary-caches.json"'';
        };
        secretsJsonPath = mkOption {
          description = ''
            Path to a JSON file containing secrets for effects.

            As these values are confidential, they should not be in the store, but
            copied over using other means, such as agenix, NixOps
            `deployment.keys`, or manual installation.

            The format is described on <https://docs.hercules-ci.com/hercules-ci-agent/secrets-json/>.
          '';
          type = types.path;
          default = config.staticSecretsDirectory + "/secrets.json";
          defaultText = literalExpression ''staticSecretsDirectory + "/secrets.json"'';
        };
      };
      config = {
        labels = {
          agent.source =
            if packageOption.highestPrio == (lib.modules.mkOptionDefault { }).priority then
              "nixpkgs"
            else
              lib.mkOptionDefault "override";
          pkgs.version = pkgs.lib.version;
          lib.version = lib.version;
        };
      };
    };
in
{
  inherit format settingsModule;
}
