{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  elfutils,
  zlib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blazesym";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "libbpf";
    repo = "blazesym";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S0IEdHSvicStWDfgdgM2QXezXx9pBrs9Zpom3RGBDys=";
  };

  cargoHash = "sha256-T7bLbqusyUnc2HpgiPOFMR71ujXQ6dvnnrtFRSqj9as=";

  cargoBuildFlags = [
    "--package"
    "blazesym-c"
  ];

  nativeCheckInputs = [
    pkg-config
    elfutils
    zlib
  ];

  cargoTestFlags = [
    "--no-run"
    "--package"
    "blazesym-c"
  ];

  postInstall = ''
    install -Dm644 capi/include/blazesym.h "$out/include/blazesym.h"
  '';

  meta = {
    description = "Library for address symbolization and related tasks";
    homepage = "https://github.com/libbpf/blazesym";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "blazesym";
  };
})
