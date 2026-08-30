{ python3Packages }:

(python3Packages.toPythonApplication python3Packages.connect-box3).overrideAttrs {
  __structuredAttrs = true;
}
