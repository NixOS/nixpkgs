{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "proton-vpn-local-agent";
  version = "unstable-20241010";
  cargoHash = "sha256-42cOoBE9ebqSiENOTTzGV5zvxwY+qm3+zvsT1uGZZWg=";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-local-agent";
    rev = "01332194d217d91a514ecaebcdfbfa3d21ccd1ed";
    hash = "sha256-I+tbVQzD4xJUsoRF8TU/2EMldVqtfxY3E7PQN3ks0mA=";
  };

  sourceRoot = "${src.name}/python-proton-vpn-local-agent";

  installPhase = ''
    # manually install the python binding
    mkdir -p $out/${python3.sitePackages}/proton/vpn/
    cp ./target/x86_64-unknown-linux-gnu/release/libpython_proton_vpn_local_agent.so $out/${python3.sitePackages}/proton/vpn/local_agent.so
  '';

  meta = {
    description = "Proton VPN local agent written in Rust with Python bindings";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-local-agent";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
