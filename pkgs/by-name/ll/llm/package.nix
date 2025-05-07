{
  lib,
  python3Packages,
  enable-llm-anthropic ? false,
}:

let
  inherit (python3Packages) toPythonApplication llm llm-anthropic;
in

toPythonApplication (
  llm.overrideAttrs (finalAttrs: {
    propagatedBuildInputs =
      (finalAttrs.propagatedBuildInputs or [])
      ++ lib.optionals enable-llm-anthropic [ llm-anthropic ];
  })
)
