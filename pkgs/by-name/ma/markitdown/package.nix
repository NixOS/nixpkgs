{ python3Packages }:

(python3Packages.toPythonApplication python3Packages.markitdown).overrideAttrs (_: {
  __structuredAttrs = true;
})
