{ lib
, boost
, fetchFromGitHub
, libsodium
, nixVersions
, pkg-config
, rustPlatform
, stdenv
, nix-update-script
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "harmonia";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "refs/tags/${pname}-v${version}";
    hash = "sha256-+V0V/l9Q7HR3J0aH1UWc1qHrpGiRWd6B4R+3MECFORg=";
  };

  cargoHash = "sha256-3Nx1YXjbYVOD7pYgI9Cp5Vsxv1j1XeX6pCl4+Q1OtVs=";

  doCheck = false;

  nativeBuildInputs = [
    pkg-config nixVersions.nix_2_21
  ];

  buildInputs = [
    boost
    libsodium
    nixVersions.nix_2_21
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
