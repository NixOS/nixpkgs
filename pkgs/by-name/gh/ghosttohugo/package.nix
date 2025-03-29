{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ghosttohugo";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "jbarone";
    repo = "ghostToHugo";
    rev = "v${version}";
    hash = "sha256-lYqjwLPvSX9/HaFvSwtkvxbCToTwfDPeVivNfazZwQA=";
  };

  vendorHash = "sha256-/7MsVLVek2nQwf8rVJQywBKiIOCGe72L45CkAElXrMo=";

  meta = with lib; {
    description = "Convert Ghost export to Hugo posts";
    homepage = "https://github.com/jbarone/ghostToHugo";
    license = licenses.mit;
    maintainers = with maintainers; [ clerie ];
    mainProgram = "ghostToHugo";
  };
}
