{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  elfutils,
  zlib,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blazesym-c";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "libbpf";
    repo = "blazesym";
    tag = "capi-v${finalAttrs.version}";
    hash = "sha256-WwL/IbR7y916yvFZGdyHlrexqoyr2wDTNalaKMCdnRs=";
  };

  cargoPatches = [ ./update-libbpf-sys.patch ];

  cargoHash = "sha256-gVGi1n4xnu1L2ONmm3DtIqNRf0czGmfGZgpRORPWTRI=";

  cargoBuildFlags = [
    "--package"
    "blazesym-c"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^capi-v([0-9.]+)$"
    ];
  };

  meta = {
    description = "C language bindings for the blazesym library";
    homepage = "https://github.com/libbpf/blazesym";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aaronjheng ];
  };
})
