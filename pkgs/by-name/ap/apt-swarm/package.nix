{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  aws-lc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "apt-swarm";
  version = "0.6.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "apt-swarm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3FPJkWyTkv078eZx8qyJd4hoLuHg0MPCU7FqahwZdS0=";
  };

  cargoHash = "sha256-Fo/+UbdfDhbAsoWjoko4tAmyDZK6tPn/0d2CjPKyaaQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  meta = {
    description = "Experimental p2p gossip network for OpenPGP signature transparency";
    homepage = "https://github.com/kpcyrd/apt-swarm";
    changelog = "https://github.com/kpcyrd/apt-swarm/releases/tag/v${finalAttrs.version}";
    mainProgram = "apt-swarm";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kpcyrd ];
    platforms = lib.platforms.all;
  };
})
