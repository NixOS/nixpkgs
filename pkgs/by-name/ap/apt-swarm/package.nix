{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "apt-swarm";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "apt-swarm";
    tag = "v${version}";
    hash = "sha256-zb0X6vIRKeI5Ysc88sTCJBlr9r8hrsTq5YR7YCg1L30=";
  };

  cargoHash = "sha256-PELTEzhsFa1nl7iqrjnuXEI0U7L8rL9XW9XqQ04rz/s=";

  meta = {
    description = "Experimental p2p gossip network for OpenPGP signature transparency";
    homepage = "https://github.com/kpcyrd/apt-swarm";
    changelog = "https://github.com/kpcyrd/apt-swarm/releases/tag/v${version}";
    mainProgram = "apt-swarm";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ kpcyrd ];
    platforms = lib.platforms.all;
  };
}
