{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.chatgpt-retrieval-plugin;
in
{
  options.services.chatgpt-retrieval-plugin = {
    enable = mkEnableOption (lib.mdDoc "chatgpt-retrieval-plugin service");

    port = mkOption {
      type = types.port;
      default = 8080;
      description = lib.mdDoc "Port the chatgpt-retrieval-plugin service listens on.";
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = lib.mdDoc "The hostname or IP address for chatgpt-retrieval-plugin to bind to.";
    };

    bearerTokenPath = mkOption {
      type = types.path;
      description = lib.mdDoc ''
        Path to the secret bearer token used for the http api authentication.
      '';
      default = "";
      example = "config.age.secrets.CHATGPT_RETRIEVAL_PLUGIN_BEARER_TOKEN.path";
    };

    openaiApiKeyPath = mkOption {
      type = types.path;
      description = lib.mdDoc ''
        Path to the secret openai api key used for embeddings.
      '';
      default = "";
      example = "config.age.secrets.CHATGPT_RETRIEVAL_PLUGIN_OPENAI_API_KEY.path";
    };

    datastore = mkOption {
      type = types.enum [ "pinecone" "weaviate" "zilliz" "milvus" "qdrant" "redis" ];
      default = "qdrant";
      description = lib.mdDoc "This specifies the vector database provider you want to use to store and query embeddings.";
    };

    qdrantCollection = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        name of the qdrant collection used to store documents.
      '';
      default = "document_chunks";
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.bearerTokenPath != "";
        message = "services.chatgpt-retrieval-plugin.bearerTokenPath should not be an empty string.";
      }
      {
        assertion = cfg.openaiApiKeyPath != "";
        message = "services.chatgpt-retrieval-plugin.openaiApiKeyPath should not be an empty string.";
      }
    ];

    systemd.services.chatgpt-retrieval-plugin = {
      description = "ChatGPT Retrieval Plugin";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        LoadCredential = [
          "BEARER_TOKEN:${cfg.bearerTokenPath}"
          "OPENAI_API_KEY:${cfg.openaiApiKeyPath}"
        ];
        StateDirectory = "chatgpt-retrieval-plugin";
        StateDirectoryMode = "0755";
      };

      # it doesn't make sense to pass secrets as env vars, this is a hack until
      # upstream has proper secret management.
      script = ''
        export BEARER_TOKEN=$(${pkgs.systemd}/bin/systemd-creds cat BEARER_TOKEN)
        export OPENAI_API_KEY=$(${pkgs.systemd}/bin/systemd-creds cat OPENAI_API_KEY)
        exec ${pkgs.chatgpt-retrieval-plugin}/bin/start --host ${cfg.host} --port ${toString cfg.port}
      '';

      environment = {
        DATASTORE = cfg.datastore;
        QDRANT_COLLECTION = mkIf (cfg.datastore == "qdrant") cfg.qdrantCollection;
      };
    };

    systemd.tmpfiles.rules = [
      # create the directory for static files for fastapi
      "C /var/lib/chatgpt-retrieval-plugin/.well-known - - - - ${pkgs.chatgpt-retrieval-plugin}/${pkgs.python3Packages.python.sitePackages}/.well-known"
    ];
  };
}
