{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "proton-vpn-local-agent";
  version = "0-unstable-2024-10-10";
  cargoHash = "sha256-yAeqx9zo4xz4g/klo10vMEcecc8npIUY8tkV/nq11WA=";

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
    cp ./target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/libpython_proton_vpn_local_agent.so $out/${python3.sitePackages}/proton/vpn/local_agent.so
  '';

  meta = {
    description = "Proton VPN local agent written in Rust with Python bindings";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-local-agent";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
