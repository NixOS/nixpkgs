{
  lib,
  rustPlatform,
  hydra,
  pkg-config,
  postgresql,
  protobuf,
  rust-jemalloc-sys,
  nixosTests,
  withOtel ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hydra-ad-hoc";
  inherit (hydra) version src;
  __structuredAttrs = true;

  cargoHash = "sha256-TYFxKCXxe5oCbmjWaaQM98VjInKBgVRr8Ygy+2LKUew=";

  cargoBuildFlags = [
    "--package"
    "hydra-ad-hoc"
  ];

  buildFeatures = lib.optional withOtel "otel";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    protobuf
    rust-jemalloc-sys
  ];

  # The tests start their own throwaway PostgreSQL instances.
  nativeCheckInputs = [ postgresql ];

  cargoTestFlags = [
    "--package"
    "hydra-ad-hoc"
  ];

  passthru.tests = { inherit (nixosTests) hydra; };

  meta = {
    description = "Experimental Hydra service presenting Hydra as one big Nix daemon for ad hoc builds";
    homepage = "https://github.com/NixOS/hydra";
    license = lib.licenses.gpl3Only;
    mainProgram = "hydra-ad-hoc";
    maintainers = with lib.maintainers; [
      conni2461
      das_j
      helsinki-Jo
      mindavi
    ];
    platforms = lib.platforms.linux;
  };
})
