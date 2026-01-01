{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcphost";
<<<<<<< HEAD
  version = "0.32.0";
=======
  version = "0.31.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mark3labs";
    repo = "mcphost";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-zTSU7phEvoiw64V9QQI3IrHA9seStjOZadWaYwjlY9w=";
  };

  vendorHash = "sha256-NBxJim9Abm9dHADXita5NHQf4hbR/IUz4VyeYpHYN2I=";
=======
    hash = "sha256-iVcoNOCD8g0HDrp4agK8m7gv4DkcYekdRlPpN41Wrf0=";
  };

  vendorHash = "sha256-4qioHQXdikYItQkYlyXp/Qtuun8FICxyzyWQx/mTSpA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  doCheck = false;

  meta = {
    description = "CLI host application that enables Large Language Models (LLMs) to interact with external tools through the Model Context Protocol (MCP)";
    homepage = "https://github.com/mark3labs/mcphost";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mcphost";
  };
})
