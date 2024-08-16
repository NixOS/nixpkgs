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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "harmonia";
    rev = "refs/tags/harmonia-v${version}";
    hash = "sha256-S5UU6/JZzp4mJKplhpJjcACr+M1rQCFQFWuyk9Wwumg=";
  };

  cargoHash = "sha256-iCltPaWNq9vWgPfjNYikoU25X8wzlM4ruYI+WgHYv7U=";

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
