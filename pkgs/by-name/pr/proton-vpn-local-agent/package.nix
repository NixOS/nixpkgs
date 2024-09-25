{
  lib,
  fetchFromGitHub,
  rustPlatform
}: rustPlatform.buildRustPackage rec {
  pname = "proton-vpn-local-agent";
  version = "unstable-20240917";
  cargoHash = "sha256-/DJGf1tD6heSzQszGwyzOmaCa2oo1x09FVRlQK8ZyHI=";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-local-agent";
    rev = "a7c706bfce46cdf7fc912faad878aba22dc6aad9";
    hash = "sha256-ygIAwHP5HLj3tjl8OyNRrid19SFyBmS6rsCofqsZPMk=";
  };

  sourceRoot = "${src.name}/python-proton-vpn-local-agent";

  installPhase = ''
    mkdir -p $out/lib
    mv target/x86_64-unknown-linux-gnu/release/libpython_proton_vpn_local_agent.so $out/lib/local_agent.so
  '';

  meta = {
    description = "Proton VPN local agent written in Rust";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-killswitch-network-manager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
