{ python3Packages }:

(python3Packages.toPythonApplication python3Packages.dnsight).overrideAttrs {
  __structuredAttrs = true;
}
