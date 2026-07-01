{ python3Packages }:

(python3Packages.toPythonApplication python3Packages.huggingface-hub).overrideAttrs {
  __structuredAttrs = true;
}
