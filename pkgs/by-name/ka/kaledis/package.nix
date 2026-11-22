{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libgit2,
  zlib,
  stdenv,
  makeWrapper,
  steam-run-free,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kaledis";
  version = "4.1.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "orpos";
    repo = "kaledis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GekS+p+3j3VY+ftuUcCfHUX18LczpWvSE0B7YTAWCFc=";
  };

  cargoHash = "sha256-I9Xw0HILgGINx2Obc8MN/7m7VL7wXbh8fpsQHN9qJXs=";

  # We exclude doctests as they're broken in the upstream release
  cargoTestFlags = [
    "--lib"
    "--bins"
    "--tests"
  ];

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    makeWrapper
  ];

  buildInputs = [
    openssl
    libgit2
    zlib
    zstd
  ];

  # Fix for the kaledis managed love executable
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p "$out/libexec"
    mv "$out/bin/kaledis" "$out/libexec/kaledis"

    makeWrapper ${steam-run-free}/bin/steam-run "$out/bin/kaledis" \
      --set APPIMAGE_EXTRACT_AND_RUN 1 \
      --add-flags "$out/libexec/kaledis"
  '';

  meta = {
    description = "Luau Transpiler for Love2D";
    license = lib.licenses.mit;
    homepage = "https://github.com/orpos/kaledis";
    changelog = "https://github.com/orpos/kaledis/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "kaledis";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ jerryx77 ];
  };
})
