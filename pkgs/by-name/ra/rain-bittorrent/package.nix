{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rain";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    tag = "v${version}";
    hash = "sha256-FU0RjWT+ewM/13n/4zCdxLVrN8ikUJCtosXsx8L8vMk=";
  };

  vendorHash = "sha256-TFIrepXZPokVu9lW2V2s3seq58yQiHceu+zRHucB+0g=";

  meta = {
    description = "BitTorrent client and library in Go";
    homepage = "https://github.com/cenkalti/rain";
    license = lib.licenses.mit;
    mainProgram = "rain";
    maintainers = with lib.maintainers; [
      justinrubek
      matthewdargan
    ];
  };
}
