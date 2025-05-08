{
  lib,
  python3Packages,
  enable-llm-anthropic ? false,
  enable-llm-cmd ? false,
  enable-llm-command-r ? false,
  enable-llm-deepseek ? false,
  enable-llm-gemini ? false,
  enable-llm-grok ? false,
  enable-llm-groq ? false,
  enable-llm-gguf ? false,
  enable-llm-jq ? false,
  enable-llm-mistral ? false,
  enable-llm-ollama ? false,
  enable-llm-openai-plugin ? false,
  enable-llm-openrouter ? false,
  enable-llm-templates-fabric ? false,
  enable-llm-templates-github ? false,
  enable-llm-venice ? false,
  enable-llm-video-frames ? false,
}:

let
  inherit (python3Packages)
    toPythonApplication
    llm
    llm-anthropic
    llm-cmd
    llm-command-r
    llm-deepseek
    llm-gemini
    llm-gguf
    llm-grok
    llm-groq
    llm-jq
    llm-mistral
    llm-ollama
    llm-openai-plugin
    llm-openrouter
    llm-templates-fabric
    llm-templates-github
    llm-venice
    llm-video-frames
    ;
in

toPythonApplication (
  llm.overrideAttrs (finalAttrs: {
    propagatedBuildInputs =
      (finalAttrs.propagatedBuildInputs or [ ])
      ++ lib.optionals enable-llm-anthropic [ llm-anthropic ]
      ++ lib.optionals enable-llm-cmd [ llm-cmd ]
      ++ lib.optionals enable-llm-cmd [ llm-command-r ]
      ++ lib.optionals enable-llm-deepseek [ llm-deepseek ]
      ++ lib.optionals enable-llm-gemini [ llm-gemini ]
      ++ lib.optionals enable-llm-gguf [ llm-gguf ]
      ++ lib.optionals enable-llm-grok [ llm-grok ]
      ++ lib.optionals enable-llm-groq [ llm-groq ]
      ++ lib.optionals enable-llm-jq [ llm-jq ]
      ++ lib.optionals enable-llm-mistral [ llm-mistral ]
      ++ lib.optionals enable-llm-ollama [ llm-ollama ]
      ++ lib.optionals enable-llm-openai-plugin [ llm-openai-plugin ]
      ++ lib.optionals enable-llm-openrouter [ llm-openrouter ]
      ++ lib.optionals enable-llm-templates-fabric [ llm-templates-fabric ]
      ++ lib.optionals enable-llm-templates-github [ llm-templates-github ]
      ++ lib.optionals enable-llm-venice [ llm-venice ]
      ++ lib.optionals enable-llm-video-frames [ llm-video-frames ];
  })
)
