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

  cargoHash = "sha256-uMb45eScPjJV3NXcqr6TMJQZI/IHYY9cXgprG2j4UJA=";

  # glibc 2.44 aarch64 headers use __u128, which the libbpf vendored in
  # libbpf-sys 1.7.0 does not provide yet (fixed upstream in f90a9c48).
  postPatch = ''
    crate=$(find "$cargoDepsCopy" -type d -name 'libbpf-sys-*' -print -quit)
    patch -d "$crate" -p1 < ${./libbpf-sys-linux-types-u128.patch}
  '';

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
