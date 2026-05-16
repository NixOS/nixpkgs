{ python3Packages }:
with python3Packages;
(toPythonApplication dnsight).overrideAttrs {
  __structuredAttrs = true;
}
