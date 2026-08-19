{ python3Packages }:
with python3Packages;
(toPythonApplication deptry).overrideAttrs (_: {
  __structuredAttrs = true;
})
