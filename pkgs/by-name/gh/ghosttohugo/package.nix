{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ghosttohugo";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "jbarone";
    repo = "ghostToHugo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lYqjwLPvSX9/HaFvSwtkvxbCToTwfDPeVivNfazZwQA=";
  };

  vendorHash = "sha256-/7MsVLVek2nQwf8rVJQywBKiIOCGe72L45CkAElXrMo=";

  meta = {
    description = "Convert Ghost export to Hugo posts";
    homepage = "https://github.com/jbarone/ghostToHugo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clerie ];
    mainProgram = "ghostToHugo";
  };
})
