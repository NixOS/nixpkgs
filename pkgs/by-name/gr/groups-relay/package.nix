{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "groups-relay";
  version = "0-unstable-2025-05-10";

  src = fetchFromGitHub {
    owner = "max21dev";
    repo = "groups-relay";
    rev = "f7f81d4daf9b2d5fb12e04e9081cf2e307763508";
    hash = "sha256-2my17kgpL+5dROB3iQN2SAe9jTPDRHPvW0QIwFun0vg=";
  };

  vendorHash = "sha256-oZgku/7KA/V3IiSH7LnJPSk2mBy3Y3RmypuGDo1d7VA=";

  meta = {
    description = "NIP-29 group chat relay for Nostr, built on khatru and relay29";
    homepage = "https://github.com/max21dev/groups-relay";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pinpox ];
    mainProgram = "groups-relay";
  };
}
