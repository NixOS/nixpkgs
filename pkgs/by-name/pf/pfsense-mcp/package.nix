{
  lib,
  python3,
  fetchFromGitHub,
  writeShellApplication,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      fastmcp
      httpx
    ]
  );

  src = fetchFromGitHub {
    owner = "abl030";
    repo = "pfsense-mcp";
    tag = "v1.0.0";
    hash = "sha256-5lnfiRUe8/3Xdfd4uz1p2jcOv2RS0zxAEtjg6u+PThA=";
  };
in
writeShellApplication {
  name = "pfsense-mcp";

  runtimeInputs = [ pythonEnv ];

  text = ''
    exec fastmcp run ${src}/generated/server.py
  '';

  meta = {
    description = "MCP server for the pfSense REST API v2 — 677 tools for AI-driven firewall management";
    homepage = "https://github.com/abl030/pfsense-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ abl030 ];
    mainProgram = "pfsense-mcp";
  };
}
