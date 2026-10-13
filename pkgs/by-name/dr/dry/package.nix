{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dry";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "moncho";
    repo = "dry";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mS7vb1geYqzj6KnkOE7j/HRdqmdipfTsFufK3v6AgdM=";
  };

  proxyVendor = true;
  vendorHash = "sha256-e8IkL+HRAWDKiw/Za899y1cuvKlaM6gUGToKvIsTZD8=";

  meta = {
    description = "Terminal application to manage Docker and Docker Swarm";
    homepage = "https://moncho.github.io/dry/";
    changelog = "https://github.com/moncho/dry/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dump_stack ];
    mainProgram = "dry";
  };
})
