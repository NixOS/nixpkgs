{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "apt-swarm";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "apt-swarm";
    tag = "v${version}";
    hash = "sha256-XE8VSMNqm131BBRIAycQebdGPiunMCG1fVnEffmej1o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Iu4CcBgcvRcERZdEZQP6fGGBVvyctpKrzFaoW/eIr5c=";

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
