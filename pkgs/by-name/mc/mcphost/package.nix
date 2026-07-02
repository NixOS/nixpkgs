{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcphost";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "mark3labs";
    repo = "mcphost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xqz6K0e/LSX77qpkmwmqgStPAfkkJdqKKDZOeYWnrRo=";
  };

  vendorHash = "sha256-mzrCIDMr1INzwqktZIc9m0SgynQC0FpyVlSlAba//sY=";

  doCheck = false;

  meta = {
    description = "CLI host application that enables Large Language Models (LLMs) to interact with external tools through the Model Context Protocol (MCP)";
    homepage = "https://github.com/mark3labs/mcphost";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mcphost";
  };
})
