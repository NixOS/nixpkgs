{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gopher64-netplay-server";
  version = "1.0.39";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gopher64";
    repo = "gopher64-netplay-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LlCM1MO6cK8rOAyt93zXOuSo/iGbNWNh3Wj01lmAhQk=";
  };

  vendorHash = "sha256-abXUtF92o73lKXJdsbrQsTEo18HUc3CP23wrgTXwN84=";

  meta = {
    description = "Dedicated netplay server for gopher64, simple64 and RMG";
    homepage = "https://github.com/gopher64/gopher64-netplay-server";
    license = lib.licenses.gpl3Only;
    mainProgram = "gopher64-netplay-server";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
