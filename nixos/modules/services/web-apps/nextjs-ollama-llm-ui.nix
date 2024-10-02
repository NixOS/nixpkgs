{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.nextjs-ollama-llm-ui;
  # we have to override the URL to a Ollama service here, because it gets baked into the web app.
  nextjs-ollama-llm-ui = cfg.package.override { inherit (cfg) ollamaUrl; };
in
{
  options = {
    services.nextjs-ollama-llm-ui = {
      enable = lib.mkEnableOption ''
        Simple Ollama web UI service; an easy to use web frontend for a Ollama backend service.
        Run state-of-the-art AI large language models (LLM) similar to ChatGPT locally with privacy
        on your personal computer.
        This service is stateless and doesn't store any data on the server; all data is kept
        locally in your web browser.
        See https://github.com/jakobhoeg/nextjs-ollama-llm-ui.

        Required: You need the Ollama backend service running by having
        "services.nextjs-ollama-llm-ui.ollamaUrl" point to the correct url.
        You can host such a backend service with NixOS through "services.ollama".
      '';
      package = lib.mkPackageOption pkgs "nextjs-ollama-llm-ui" { };

      hostname = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "ui.example.org";
        description = ''
          The hostname under which the Ollama UI interface should be accessible.
          By default it uses localhost/127.0.0.1 to be accessible only from the local machine.
          Change to "0.0.0.0" to make it directly accessible from the local network.

          Note: You should keep it at 127.0.0.1 and only serve to the local
          network or internet from a (home) server behind a reverse-proxy and secured encryption.
          See https://wiki.nixos.org/wiki/Nginx for instructions on how to set up a reverse-proxy.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        example = 3000;
        description = ''
          The port under which the Ollama UI interface should be accessible.
        '';
      };

      ollamaUrl = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1:11434";
        example = "https://ollama.example.org";
        description = ''
          The address (including host and port) under which we can access the Ollama backend server.
          !Note that if the the UI service is running under a domain "https://ui.example.org",
          the Ollama backend service must allow "CORS" requests from this domain, e.g. by adding
          "services.ollama.environment.OLLAMA_ORIGINS = [ ... "https://ui.example.org" ];"!
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {

      nextjs-ollama-llm-ui = {
        wantedBy = [ "multi-user.target" ];
        description = "Nextjs Ollama LLM Ui.";
        after = [ "network.target" ];
        environment = {
          HOSTNAME = cfg.hostname;
          PORT = toString cfg.port;
          NEXT_PUBLIC_OLLAMA_URL = cfg.ollamaUrl;
        };
        serviceConfig = {
          ExecStart = "${lib.getExe nextjs-ollama-llm-ui}";
          DynamicUser = true;
        };
      };
    };
  };
  meta.maintainers = with lib.maintainers; [ malteneuss ];
}
