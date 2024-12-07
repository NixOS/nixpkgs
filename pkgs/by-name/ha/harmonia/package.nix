{ lib
, boost
, fetchFromGitHub
, libsodium
, nixVersions
, nlohmann_json
, openssl
, pkg-config
, rustPlatform
, nix-update-script
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "harmonia";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "harmonia";
    rev = "refs/tags/harmonia-v${version}";
    hash = "sha256-tG8aazgNIuABlh2RkL6Ca0EaryLhP15X+dz2UcwGfOk=";
  };

  cargoHash = "sha256-QccBuXZ9YS5w/Dip0qior0EWIbuMgwqjBaeemkJ6GAk=";

  doCheck = false;

  nativeBuildInputs = [
    pkg-config nixVersions.nix_2_24
  ];

  buildInputs = [
    boost
    libsodium
    openssl
    nlohmann_json
    nixVersions.nix_2_24
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "harmonia-v(.*)" ];
    };
    tests = { inherit (nixosTests) harmonia; };
  };

  meta = with lib; {
    description = "Nix binary cache";
    homepage = "https://github.com/nix-community/harmonia";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    mainProgram = "harmonia";
  };
}
