{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "proton-vpn-local-agent";
  version = "1.2.0";
  cargoHash = "sha256-qxNbHM6KmBmLbruOhbFIp3klz6RuKWBLioVsBPDQiLI=";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-local-agent";
    rev = version;
    hash = "sha256-1iUeAWojIcXbvO6YoPEh//dbVdl90cUocyO3nfDtUEM";
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
