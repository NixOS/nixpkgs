{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcphost";
  version = "0.33.4";

  src = fetchFromGitHub {
    owner = "mark3labs";
    repo = "mcphost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RtNm5+MoB/VndGFTBYf1yC60dBaT3YrJqIuaT+f++L4=";
  };

  vendorHash = "sha256-yRRe1LBdB4vdW1WM6jOi58gv2tLs2eeSFHFG/d4afyY=";

  doCheck = false;

  meta = {
    description = "CLI host application that enables Large Language Models (LLMs) to interact with external tools through the Model Context Protocol (MCP)";
    homepage = "https://github.com/mark3labs/mcphost";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mcphost";
  };
})
