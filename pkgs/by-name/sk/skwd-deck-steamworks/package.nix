{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  bash,
  skwd-paper-v2,
  skwd-lens,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  stricDeps = true;
  pname = "skwd-deck-steamworks";
  version = "1.0.0-beta.26";
  src = fetchFromGitHub {
    owner = "liixini";
    repo = "skwd-deck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6qQUSY5yoM5T0JycCEht8rzl168kALK82uv2w9u5gaQ=";
  };
  cargoHash = "sha256-a44ZfjiBvzFEyLdE13geaQ51on33mqO0im1qBiRxYgU=";

  postUnpack = ''
    cp -r --no-preserve=mode,ownership ${skwd-paper-v2.src} $NIX_BUILD_TOP/skwd-paper
    cp -r --no-preserve=mode,ownership ${skwd-lens.src} $NIX_BUILD_TOP/skwd-lens
  '';

  postPatch = ''
    while IFS= read -r -d ""; do
      substituteInPlace "$REPLY" --replace-quiet '#!/bin/sh' '#!${bash}/bin/sh'
    done < <(grep -n 'bin/sh' $(find . -name '*.rs'))
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  cargoBuildFlags = [
    "--manifest-path"
    "Cargo.toml"
    "--package"
    "skwd-steam"
    "--bin"
    "skwd-steam"
  ];

  cargoTestFlags = [
    "--manifest-path"
    "Cargo.toml"
    "--package"
    "skwd-steam"
    "--bin"
    "skwd-steam"
  ];

  meta = {
    description = "Optional Steam Client Workshop backend for Skwd Deck";
    homepage = "https://github.com/liixini/skwd-wall";
    license = with lib.licenses; [
      mit
      valveSDK
    ];
    maintainers = with lib.maintainers; [
      futurekismo
      HomieDerPrakti
    ];
    mainProgram = "skwd-steam";
    platforms = [ "x86_64-linux" ];
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=unstable" ];
  };
})
