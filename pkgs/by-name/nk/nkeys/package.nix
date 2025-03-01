{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nkeys";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-vSjIqeGWS9sDGyrPD11u4ngiZrW6gZfYd08kKXUDXdU=";
  };

  vendorHash = "sha256-TtplWIDLUsFXhT5OQVhW3KTfxh1MVY8Hssejy8GBYVQ=";

  meta = with lib; {
    description = "Public-key signature system for NATS";
    homepage = "https://github.com/nats-io/nkeys";
    changelog = "https://github.com/nats-io/nkeys/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nk";
  };
}
