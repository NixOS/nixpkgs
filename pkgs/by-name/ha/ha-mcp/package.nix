{ python3Packages }:

let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      mcp = final.mcp_1;
    }
  );
in
pythonPackages.toPythonApplication pythonPackages.ha-mcp
