{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.zsh.zsh-ai;
  zshAiPkg = pkgs.zsh-ai;
in
{
  options.programs.zsh.zsh-ai = {
    enable = lib.mkEnableOption "zsh-ai natural language shell command generator";

    provider = lib.mkOption {
      type = lib.types.enum [
        "anthropic"
        "openai"
        "ollama"
        "apfel"
        "gemini"
        "qwen"
        "grok"
        "mistral"
        "custom"
      ];
      default = "ollama";
      description = "The AI provider backend to use for zsh-ai.";
    };

    trigger = lib.mkOption {
      type = lib.types.str;
      default = "# ";
      description = "The inline prompt trigger string for zsh-ai.";
    };

    commentHook = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use the inline comment hook. If false, only explicit 'zsh-ai \"...\"' commands work.";
    };

    promptExtend = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "Prefer rg over grep, fd over find, and bat over cat.";
      description = "Additional instructions to extend the system prompt without replacing built-in command rules.";
    };

    # Provider-specific settings from the upstream README
    ollama = {
      model = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "gemma4:e2b-it-qat";
        description = "Model name for Ollama.";
      };
      url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "http://localhost:11434";
        description = "Base URL for Ollama server (no /v1 suffix).";
      };
    };

    openai = {
      model = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Model name for OpenAI or compatible endpoints.";
      };
      url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Full endpoint URL for OpenAI-compatible servers.";
      };
      thinking = lib.mkOption {
        type = lib.types.nullOr lib.types.enum [
          "0"
          "1"
        ];
        default = null;
        description = "Maps to chat_template_kwargs.enable_thinking for supported servers.";
      };
      reasoningEffort = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "none";
        description = "Reasoning effort parameter for supported models.";
      };
      maxTokens = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.positive;
        default = null;
        example = 256;
        description = "Maximum token limit for model outputs.";
      };
    };

    apfel = {
      url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "http://127.0.0.1:11435/v1/chat/completions";
        description = "Loopback endpoint URL for Apple on-device Apfel service.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.interactiveShellInit = ''
      export ZSH_AI_PROVIDER="${cfg.provider}"
      export ZSH_AI_TRIGGER="${cfg.trigger}"
      export ZSH_AI_COMMENT_HOOK="${toString cfg.commentHook}"
      ${lib.optionalString (
        cfg.promptExtend != null
      ) ''export ZSH_AI_PROMPT_EXTEND="${cfg.promptExtend}"''}

      # Ollama configurations
      ${lib.optionalString (
        cfg.ollama.model != null
      ) ''export ZSH_AI_OLLAMA_MODEL="${cfg.ollama.model}"''}
      ${lib.optionalString (cfg.ollama.url != null) ''export ZSH_AI_OLLAMA_URL="${cfg.ollama.url}"''}

      # OpenAI / compatible configurations
      ${lib.optionalString (
        cfg.openai.model != null
      ) ''export ZSH_AI_OPENAI_MODEL="${cfg.openai.model}"''}
      ${lib.optionalString (cfg.openai.url != null) ''export ZSH_AI_OPENAI_URL="${cfg.openai.url}"''}
      ${lib.optionalString (
        cfg.openai.thinking != null
      ) ''export ZSH_AI_OPENAI_THINKING="${cfg.openai.thinking}"''}
      ${lib.optionalString (
        cfg.openai.reasoningEffort != null
      ) ''export ZSH_AI_OPENAI_REASONING_EFFORT="${cfg.openai.reasoningEffort}"''}
      ${lib.optionalString (
        cfg.openai.maxTokens != null
      ) ''export ZSH_AI_OPENAI_MAX_TOKENS="${toString cfg.openai.maxTokens}"''}

      # Apfel configuration
      ${lib.optionalString (cfg.apfel.url != null) ''export ZSH_AI_APFEL_URL="${cfg.apfel.url}"''}

      source ${zshAiPkg}/share/zsh-ai/zsh-ai.plugin.zsh
    '';
  };
}
