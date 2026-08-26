{ lib, config, ... }:
with lib.types;
let
  # A name containing only "safe" characters that we allow passing to the
  # backends.
  #
  # Note that we often default options of type `safeName` to Nix attribute
  # names. For example,
  # ```
  # secrets.store."foo bar" = {}
  # ```
  # will implicitly set `secrets.store."foo bar".name = "foo bar"`. This is
  # bad, because the error will get a confusing error coming from the wrong
  # place. In the future, it might be worth creating a modified version of
  # `attrsOf` that does not have this issue, although the added complexity is
  # not worth it right now.
  safeName =
    of:
    addCheck str (
      s:
      if lib.strings.match "^[a-zA-Z0-9:_\\.-]+$" s == null then
        throw "Name '${toString s}' is not a valid ${of} name. Currently, only alphanumeric characters, dashes, underscores, and dots are allowed."
      else
        true
    );
  cfg = config.secrets;

  deferredPackage =
    description:
    lib.mkOption {
      inherit description;
      type = functionTo pathInStore;
      example = pkgs: pkgs.writeShellScript "example" "echo 'Hi!'";
    };

  nullableDeferredPackage =
    description:
    lib.mkOption {
      inherit description;
      type = nullOr (functionTo pathInStore);
      example = pkgs: pkgs.writeShellScript "example" "echo 'Hi!'";
      default = null;
    };

  storeBackendModule = submodule (
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          description = "The name of the backend.";
          type = str;
          default = name;
        };

        get = nullableDeferredPackage ''
          Given $1=gen_name and $2=file_name, the script retrieves the
          respective secret to $out.
        '';

        set = deferredPackage ''
          Given $1=gen_name and $2=file_name, the script retrieves the
          respective secret from $in and stores it in the appropriate location.
        '';

        exists = deferredPackage ''
          Given $1=gen_name and $2=file_name, the script exists with status
          code 0 if the secret exists, and with status code 42 otherwise.

          This script must not perform side effects.
        '';

        delete = nullableDeferredPackage ''
          Given $1=gen_name and $2=file_name, the script deletes the respective
          secret if it does exist.
        '';

        list = nullableDeferredPackage ''
          A script that lists all files managed by this backend. Should output
          space-separated or newline-separated pairs of: secret_name
          file_name.

          If the backend supports multiple hosts, then this command should only
          list the secrets owned by the current host. In particular, files
          included in this command's output will be deleted by the
          collect-garbage command, unless they appear in the user's secret
          configuration.

          This script must not perform side effects.
        '';

        fixup = nullableDeferredPackage ''
          This script will be run on every invocation of the CLI's "generate"
          command. Given $1=file_list in the same format used by `list`, the
          script performs any necessary updates to the secrets' files (e.g.
          rekeying encrypted secrets). This script can perform side effects,
          but must be idempotent.
        '';

        deploy.remote = nullableDeferredPackage ''
          Deploys every available file to the given machine. The list of files
          to deploy is provided as $1 in the same format used by `list`. Any
          additional information required by the deploy script can be provided
          by the user through environment variables.
        '';

        deploy.local = nullableDeferredPackage ''
          Deploys every available file to the machine with system root mounted
          at $1=system_root. The list of files to deploy is provided as $2 in
          the same format used by `list`. This is useful for fresh installs
          from environments live live CDs, where the target system is not yet
          up and running (even if nixos-install has successfully completed).
        '';

        fileModule = lib.mkOption {
          type = deferredModule;
          internal = true;
          default = { };
          description = ''
            A module to be imported in every
            secrets.store.<name>.files.<name> submodule. Used by backends to
            define the `path` attribute. The module will have the following
            additional arguments passed to it:
            - `secret`, containing the secret the file belongs to
            - `backend`, containing the backend associated with said secret
          '';
        };
      };
    }
  );

  fileModule =
    { name, backend, ... }:
    {
      imports = [ backend.fileModule ];
      options = {
        name = lib.mkOption {
          description = "name of the file";
          type = safeName "file";
          default = name;
          defaultText = "Name of the file";
        };

        path = lib.mkOption {
          description = "Path to the file; usually set by the backend";
          type = path;
        };

        deploy = lib.mkOption {
          description = ''
            Files with this flag will be included in the file list passed to
            the `deploy` script.
          '';
          type = bool;
          default = true;
        };
      };
    };

  secretModule = submodule (
    { name, config, ... }:
    let
      backend = cfg.backends.store.${config.backend};
    in
    {
      options = {
        name = lib.mkOption {
          description = ''
            The name of the secret. This name will be used to refer to the
            the secrets from other generators.
          '';
          type = safeName "secret";
          default = name;
          defaultText = "Attribute name of the secret";
        };

        backend = lib.mkOption {
          type = str;
          description = "The backend responsible for handling this secret.";
          default = cfg.backends.defaults.store;
        };

        prompts = lib.mkOption {
          description = ''
            A set of prompts the generator will have at its disposal.
          '';
          default = { };
          type = attrsOf promptModule;
        };

        dependencies = lib.mkOption {
          description = ''
            A list of other secrets this generator should be able to read the
            output(s) of.
          '';
          type = listOf (safeName "secret");
          default = [ ];
        };

        files = lib.mkOption {
          description = ''
            A set of files to store. The generator 'script' is expected to
            produce exactly these files under $out.
          '';
          default = { };
          type = attrsOf (submoduleWith {
            modules = [ fileModule ];
            specialArgs = {
              inherit backend;
              secret = config;
            };
          });
        };

        generate = nullableDeferredPackage ''
          The script to run to generate the files. The script will be run with
          the following environment variables:
            - $in: The directory containing the output values of all declared
              dependencies
            - $out: The output directory to put the generated files
            - $prompts: The directory containing the prompted values as files
          The script should produce the files specified in the 'files' attribute
          under $out.
        '';
      };
    }
  );

  promptBackendModule = submodule (
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          description = "The name of the backend.";
          type = str;
          default = name;
        };

        ask = deferredPackage ''
          Given $1=secret_name, $2=prompt_name, $3=prompt_type,
          $4=prompt_label, and optionally $5=prompt_description, the script
          runs the prompt by the user, then saves respective value to $out.

          Do note that the given $2=prompt_name is not meant as a prompt label!
          $4=prompt_label should be used for that purpose. Indeed, $1 and $2
          are only really useful for non-interactive usecases.
        '';
      };
    }
  );

  promptModule = submodule (
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          description = "The prompt's name.";
          type = safeName "prompt";
          default = name;
        };

        label = lib.mkOption {
          description = "The label to attach to the prompt.";
          type = str;
          default = name;
        };

        description = lib.mkOption {
          description = ''
            An optional longer description of the prompted value.
          '';
          type = nullOr str;
          default = null;
          example = "SSH private key";
        };

        type = lib.mkOption {
          description = ''
            The input type of the prompt.
            The following types are available:
              - hidden: A hidden text (e.g. password)
              - line: A single line of text
              - multiline: A multiline text
          '';
          type = enum [
            "hidden"
            "line"
            "multiline"
          ];
          default = "line";
        };

        backend = lib.mkOption {
          type = str;
          description = "The backend responsible for handling this prompt.";
          default = cfg.backends.defaults.prompt;
        };
      };
    }
  );
in
{
  options.secrets = {
    store = lib.mkOption {
      description = ''
        A set of secrets that are each expected to store a set of files
        under a directory. Generators can produce files using a script,
        possibly referencing values produced by other generators and user
        input. The secrets can also be manually imported from external files
        using the CLI.
      '';
      default = { };
      type = attrsOf secretModule;
    };

    backends.store = lib.mkOption {
      description = ''
        A set of backends that handle storing and retrieving secret files.
      '';
      default = { };
      type = attrsOf storeBackendModule;
    };

    backends.defaults.store = lib.mkOption {
      description = ''
        The default backend to use for secrets that do not specify one.
      '';
      type = str;
    };

    backends.prompt = lib.mkOption {
      description = ''
        A set of backends that handle retrieving user inputs.
      '';
      default = { };
      type = attrsOf promptBackendModule;
    };

    backends.defaults.prompt = lib.mkOption {
      description = ''
        The default backend to use for prompts that do not specify one.
      '';
      type = str;
    };
  };
}
