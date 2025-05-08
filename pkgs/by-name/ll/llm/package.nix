{
  lib,
  python3Packages,
  enable-llm-anthropic ? false,
  enable-llm-cmd ? false,
}:

let
  inherit (python3Packages)
    toPythonApplication
    llm
    llm-anthropic
    llm-cmd
    ;
in

toPythonApplication (
  llm.overrideAttrs (finalAttrs: {
    propagatedBuildInputs =
      (finalAttrs.propagatedBuildInputs or [ ])
      ++ lib.optionals enable-llm-anthropic [ llm-anthropic ]
      ++ lib.optionals enable-llm-cmd [ llm-cmd ];
  })
)
