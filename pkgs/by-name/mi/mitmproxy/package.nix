{ python3Packages }:

let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      aioquic = final.aioquic_1_2;
    }
  );
in
with pythonPackages;
toPythonApplication mitmproxy
