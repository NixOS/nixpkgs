{ lib, ... }:
with lib;
let
  upstreamType = types.submodule {
    options = {
      type = mkOption {
        type = types.enum [
          "internal"
          "external"
        ];
        description = "Type of upstream: internal (another Gradient cache) or external (Nix binary cache URL)";
      };

      cache_name = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Name of the internal Gradient cache to use as upstream (required for internal type)";
      };

      display_name = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Display name for the upstream (optional for internal, required for external)";
      };

      mode = mkOption {
        type = types.enum [
          "ReadWrite"
          "ReadOnly"
          "WriteOnly"
        ];
        default = "ReadWrite";
        description = "Access mode for internal upstreams (ignored for external, which is always ReadOnly)";
      };

      url = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "URL of the external Nix binary cache (required for external type)";
      };

      public_key = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Public key of the external Nix binary cache (required for external type)";
      };
    };
  };

  userType = types.submodule (
    { config, name, ... }:
    {
      options = {
        username = mkOption {
          type = types.str;
          default = name;
          defaultText = "<attrset key>";
          description = "Unique username for the user";
        };

        name = mkOption {
          type = types.str;
          default = config.username;
          defaultText = "config.username";
          description = "Full name of the user";
        };

        email = mkOption {
          type = types.str;
          description = "Email address of the user";
        };

        password_file = mkOption {
          type = types.str;
          description = "Path to file containing the hashed password";
        };

        email_verified = mkOption {
          type = types.bool;
          default = true;
          description = "Whether the user's email has been verified";
        };
      };
    }
  );

  organizationType = types.submodule (
    { config, name, ... }:
    {
      options = {
        name = mkOption {
          type = types.str;
          default = name;
          defaultText = "<attrset key>";
          description = "Unique name for the organization";
        };

        display_name = mkOption {
          type = types.str;
          default = config.name;
          defaultText = "config.name";
          description = "Display name for the organization";
        };

        description = mkOption {
          type = types.str;
          default = "";
          description = "Description of the organization";
        };

        private_key_file = mkOption {
          type = types.str;
          description = "Path to SSH private key file for Git access";
        };

        use_nix_store = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to use Nix store for this organization";
        };

        public = mkOption {
          type = types.bool;
          default = false;
          description = "Whether the organization is public (visible to all users)";
        };

        created_by = mkOption {
          type = types.str;
          description = "Username of the user who created this organization";
        };
      };
    }
  );

  projectType = types.submodule (
    { config, name, ... }:
    {
      options = {
        name = mkOption {
          type = types.str;
          default = name;
          defaultText = "<attrset key>";
          description = "Unique name for the project";
        };

        organization = mkOption {
          type = types.str;
          description = "Name of the organization this project belongs to";
        };

        display_name = mkOption {
          type = types.str;
          default = config.name;
          defaultText = "config.name";
          description = "Display name for the project";
        };

        description = mkOption {
          type = types.str;
          default = "";
          description = "Description of the project";
        };

        repository = mkOption {
          type = types.str;
          description = "Git repository URL for the project";
        };

        evaluation_wildcard = mkOption {
          type = types.str;
          default = "packages.x86_64-linux.*";
          description = "Branch or pattern for evaluations";
        };

        active = mkOption {
          type = types.bool;
          default = true;
          description = "Whether the project is active";
        };

        force_evaluation = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to force evaluation on next check";
        };

        created_by = mkOption {
          type = types.str;
          description = "Username of the user who created this project";
        };
      };
    }
  );

  serverType = types.submodule (
    {
      config,
      name,
      pkgs,
      ...
    }:
    {
      options = {
        name = mkOption {
          type = types.str;
          default = name;
          defaultText = "<attrset key>";
          description = "Unique name for the server";
        };

        display_name = mkOption {
          type = types.str;
          default = config.name;
          defaultText = "config.name";
          description = "Display name for the server";
        };

        organization = mkOption {
          type = types.str;
          description = "Name of the organization this server belongs to";
        };

        active = mkOption {
          type = types.bool;
          default = true;
          description = "Whether the server is active";
        };

        host = mkOption {
          type = types.str;
          default = "localhost";
          description = "Hostname or IP address of the server";
        };

        port = mkOption {
          type = types.port;
          default = 22;
          description = "SSH port of the server";
        };

        username = mkOption {
          type = types.str;
          description = "SSH username for connecting to the server";
        };

        architectures = mkOption {
          type = types.listOf (
            types.enum [
              "x86_64-linux"
              "aarch64-linux"
              "x86_64-darwin"
              "aarch64-darwin"
            ]
          );
          default = [ pkgs.system ];
          description = "List of architectures supported by this server";
        };

        features = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "List of feature names supported by this server";
        };

        max_concurrent_builds = mkOption {
          type = types.ints.positive;
          default = 1;
          description = "Maximum number of builds that can run concurrently on this server";
        };

        created_by = mkOption {
          type = types.str;
          description = "Username of the user who created this server";
        };
      };
    }
  );

  cacheType = types.submodule (
    { config, name, ... }:
    {
      options = {
        name = mkOption {
          type = types.str;
          default = name;
          defaultText = "<attrset key>";
          description = "Unique name for the cache";
        };

        display_name = mkOption {
          type = types.str;
          default = config.name;
          defaultText = "config.name";
          description = "Display name for the cache";
        };

        description = mkOption {
          type = types.str;
          default = "";
          description = "Description of the cache";
        };

        active = mkOption {
          type = types.bool;
          default = true;
          description = "Whether the cache is active";
        };

        priority = mkOption {
          type = types.ints.positive;
          default = 10;
          description = "Priority of the cache (higher is more important)";
        };

        signing_key_file = mkOption {
          type = types.str;
          description = "Path to file containing the Nix cache signing key";
        };

        organizations = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "List of organization names that can use this cache";
        };

        upstreams = mkOption {
          type = types.listOf upstreamType;
          default = [ ];
          description = "List of upstream caches (internal Gradient caches or external Nix binary caches) to use as substituters";
          example = literalExpression ''
            [
              {
                type = "external";
                display_name = "cache.nixos.org";
                url = "https://cache.nixos.org";
                public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
              }
              {
                type = "internal";
                cache_name = "other-cache";
                mode = "ReadOnly";
              }
            ]
          '';
        };

        public = mkOption {
          type = types.bool;
          default = false;
          description = "Whether the cache is public (available to all organizations)";
        };

        created_by = mkOption {
          type = types.str;
          description = "Username of the user who created this cache";
        };
      };
    }
  );

  apiKeyType = types.submodule (
    { name, ... }:
    {
      options = {
        name = mkOption {
          type = types.str;
          default = name;
          defaultText = "<attrset key>";
          description = "Name of the API key";
        };

        key_file = mkOption {
          type = types.str;
          description = "Path to file containing the API key value";
        };

        owned_by = mkOption {
          type = types.str;
          description = "Username of the user who owns this API key";
        };
      };
    }
  );

  stateType = types.submodule {
    options = {
      users = mkOption {
        type = types.attrsOf userType;
        default = { };
        description = "Attribute set of users to create, keyed by username";
      };

      organizations = mkOption {
        type = types.attrsOf organizationType;
        default = { };
        description = "Attribute set of organizations to create, keyed by name";
      };

      projects = mkOption {
        type = types.attrsOf projectType;
        default = { };
        description = "Attribute set of projects to create, keyed by name";
      };

      servers = mkOption {
        type = types.attrsOf serverType;
        default = { };
        description = "Attribute set of servers to create, keyed by name";
      };

      caches = mkOption {
        type = types.attrsOf cacheType;
        default = { };
        description = "Attribute set of caches to create, keyed by name";
      };

      api_keys = mkOption {
        type = types.attrsOf apiKeyType;
        default = { };
        description = "Attribute set of API keys to create, keyed by name";
      };
    };
  };
in
{
  options.services.gradient = {
    state = mkOption {
      type = stateType;
      default = { };
      description = "Gradient state configuration for users, organizations, projects, servers, and caches";
      example = literalExpression ''
        {
          users = {
            alice = {
              name = "Alice Johnson";
              email = "alice@example.com";
              password_file = "/etc/gradient/secrets/alice_password";
              email_verified = true;
            };
          };
          organizations = {
            acme-corp = {
              display_name = "ACME Corporation";
              description = "Main development organization";
              private_key_file = "/etc/gradient/secrets/acme_ssh_key";
              use_nix_store = true;
              created_by = "alice";
            };
          };
          projects = {
            web-app = {
              organization = "acme-corp";
              display_name = "Web Application";
              description = "Main web application";
              repository = "https://github.com/acme-corp/web-app.git";
              evaluation_wildcard = "main";
              active = true;
              created_by = "alice";
            };
          };
          servers = {
            build-server-1 = {
              display_name = "Build Server 1";
              organization = "acme-corp";
              host = "build1.internal.acme.com";
              username = "gradient";
              architectures = [ "x86_64-linux" "aarch64-linux" ];
              features = [ "big-parallel" ];
              created_by = "alice";
            };
          };
          caches = {
            main-cache = {
              display_name = "Main Binary Cache";
              description = "Primary binary cache";
              signing_key_file = "/etc/gradient/secrets/main_cache_key";
              organizations = [ "acme-corp" ];
              created_by = "alice";
            };
          };
        }
      '';
    };
  };
}
