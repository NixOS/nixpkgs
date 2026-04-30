{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "apt-swarm";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "apt-swarm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tDIwx+Eb/5EH9p407+FfKAwU6ZjNxyKtfFe5h7eTnHg=";
  };

  cargoHash = "sha256-43TFrddQvmzUzk2JnggKKWljBNzO+7IYF8HsTwez7a4=";

  meta = {
    description = "Experimental p2p gossip network for OpenPGP signature transparency";
    homepage = "https://github.com/kpcyrd/apt-swarm";
    changelog = "https://github.com/kpcyrd/apt-swarm/releases/tag/v${finalAttrs.version}";
    mainProgram = "apt-swarm";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ kpcyrd ];
    platforms = lib.platforms.all;
  };
})
