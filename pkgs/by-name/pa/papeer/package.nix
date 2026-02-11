{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "papeer";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "lapwat";
    repo = "papeer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Qe+3rHEV+Env5sr9acdDqEzAi3PeN8/7fLoDz/B6GWo=";
  };

  vendorHash = "sha256-yGoRvPwlXA6FN67nQH/b0QpGQ2xXTCmXWNLInlcVk7k=";

  doCheck = false; # uses network

  meta = {
    description = "Convert websites into ebooks and markdown";
    mainProgram = "papeer";
    homepage = "https://papeer.tech/";
    license = lib.licenses.gpl3Plus;
  };
})
