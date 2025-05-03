{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:

rustPlatform.buildRustPackage rec {
  pname = "hired";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "sidju";
    repo = "hired";
    tag = version;
    hash = "sha256-Vblqunnd2pj7SJ3+dSqeIANOs6MIAxA2KB8pil3sHpc=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-PTAPnKVTaAKoRRRYRGpK8wsxMIcA6gJEzBGYQf2RmBs=";
  useFetchCargoVendor = true;

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

  meta = {
    description = "Modern take on ed, the standard Unix editor";
    homepage = "https://github.com/sidju/hired";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "hired";
  };
}
