{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gotree";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "elbachir-one";
    repo = "gt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0wYuIaGkJHSD8La1yfBYNPDB8ETtID8e5lgahqQgjLM=";
  };

  vendorHash = null;

  meta = {
    description = "Display a tree of files and directories";
    homepage = "https://github.com/elbachir-one/gt";
    changelog = "https://github.com/elbachir-one/gt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    mainProgram = "gt";
    maintainers = with lib.maintainers; [ schnow265 ];
  };
})
