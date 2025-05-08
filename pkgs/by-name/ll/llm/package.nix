{
  lib,
  python3Packages,
  enable-llm-anthropic ? false,
  enable-llm-cmd ? false,
  enable-llm-gemini ? false,
}:

let
  inherit (python3Packages)
    toPythonApplication
    llm
    llm-anthropic
    llm-cmd
    llm-gemini
    ;
in

toPythonApplication (
  llm.overrideAttrs (finalAttrs: {
    propagatedBuildInputs =
      (finalAttrs.propagatedBuildInputs or [ ])
      ++ lib.optionals enable-llm-anthropic [ llm-anthropic ]
      ++ lib.optionals enable-llm-cmd [ llm-cmd ]
      ++ lib.optionals enable-llm-gemini [ llm-gemini ];
  })
)
