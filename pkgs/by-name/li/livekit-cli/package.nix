{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "livekit-cli";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit-cli";
    rev = "v${version}";
    hash = "sha256-IARQ5yxktem729SrxdT5i+7+1dY60xw+2KZU+unlsKM=";
  };

  vendorHash = "sha256-3ePOwEEPexM+k0atW/mW4yNVtnsEXwv1w5NVQLyexbs=";

  subPackages = [ "cmd/livekit-cli" ];

  meta = with lib; {
    description = "Command line interface to LiveKit";
    homepage = "https://livekit.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mgdelacroix ];
    mainProgram = "livekit-cli";
  };
}
