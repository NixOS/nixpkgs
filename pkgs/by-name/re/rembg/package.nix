{ python3Packages }:

let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      # Necessary until gradio works with mcp 2.x
      mcp = final.mcp_1;
    }
  );
in
pythonPackages.toPythonApplication (pythonPackages.rembg.override { withCli = true; })
