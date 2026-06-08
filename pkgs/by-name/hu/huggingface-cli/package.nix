{ python3Packages }:

let
  inherit (python3Packages) toPythonApplication huggingface-hub;
in
(toPythonApplication huggingface-hub).overrideAttrs {
  __structuredAttrs = true;
}
