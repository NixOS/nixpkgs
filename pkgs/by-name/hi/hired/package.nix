{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  oniguruma,
}:

rustPlatform.buildRustPackage rec {
  pname = "hired";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "sidju";
    repo = "hired";
    tag = version;
    hash = "sha256-A1iz34CSc6GWo6FvkGwIgUwMmYaIzwdCzZFACFSZ9qI=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-nWc3vcqYbJnjYLjKyZQBFR7tSaPaSu0+TvOIBAKKtnQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  enableParallelBuilding = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modern take on ed, the standard Unix editor";
    homepage = "https://github.com/sidju/hired";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "hired";
  };
}
