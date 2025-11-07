{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "clapboard";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "clapboard";
    rev = "v${version}";
    hash = "sha256-vRIwdbt8f9/K7QAfFtBXrr4ezymlnzarq08W7J3aRiU=";
  };

  cargoHash = "sha256-w3VR6j1ZcMQsk8r9eDqMtRJrGS6+XRM8t/pf5GpTVFA=";

  meta = with lib; {
    description = "Wayland clipboard manager that will make you clap";
    homepage = "https://github.com/bjesus/clapboard";
    license = licenses.mit;
    maintainers = with maintainers; [
      dit7ya
      bjesus
    ];
    platforms = platforms.linux;
    mainProgram = "clapboard";
  };
}
