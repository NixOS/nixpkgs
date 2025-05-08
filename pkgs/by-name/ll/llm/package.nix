{
  lib,
  python3Packages,
  enable-llm-anthropic ? false,
  enable-llm-cmd ? false,
  enable-llm-gemini ? false,
  enable-llm-gguf ? false,
  enable-llm-jq ? false,
  enable-llm-ollama ? false,
  enable-llm-openai-plugin ? false,
}:

let
  inherit (python3Packages)
    toPythonApplication
    llm
    llm-anthropic
    llm-cmd
    llm-gemini
    llm-gguf
    llm-jq
    llm-ollama
    llm-openai-plugin
    ;
in

toPythonApplication (
  llm.overrideAttrs (finalAttrs: {
    propagatedBuildInputs =
      (finalAttrs.propagatedBuildInputs or [ ])
      ++ lib.optionals enable-llm-anthropic [ llm-anthropic ]
      ++ lib.optionals enable-llm-cmd [ llm-cmd ]
      ++ lib.optionals enable-llm-gemini [ llm-gemini ]
      ++ lib.optionals enable-llm-gguf [ llm-gguf ]
      ++ lib.optionals enable-llm-jq [ llm-jq ]
      ++ lib.optionals enable-llm-ollama [ llm-ollama ]
      ++ lib.optionals enable-llm-openai-plugin [ llm-openai-plugin ];
  })
)
