{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libpff,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pff-tools";
  version = "0-unstable-2025-07-22";

  src = fetchFromGitHub {
    owner = "avranju";
    repo = "pff-tools";
    rev = "d8776cd45e62c82adbbcc04f2f636b569de057ca";
    hash = "sha256-MDMrKaq/iz5WdLhh3rv2ODFdaMoaeFtacT8xmRf3Qec=";
  };

  cargoHash = "sha256-SL+FTuVkgq0ll8SH7FgVapvemarc7ci0KtoGG16zxCM=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libpff
  ];

  # Tests require a sample PST/OST file.
  doCheck = false;

  meta = {
    description = "Command-line tools to process PFF files";
    homepage = "https://github.com/avranju/pff-tools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ d3vil0p3r ];
    mainProgram = "pff-cli";
  };
})
