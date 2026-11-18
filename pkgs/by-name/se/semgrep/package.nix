{ python3Packages }:
let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      # semgrep is incompatible with mcp v2
      mcp = final.mcp_1;
    }
  );
in
pythonPackages.toPythonApplication pythonPackages.semgrep
