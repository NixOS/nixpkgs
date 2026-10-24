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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kaledis";
  version = "4.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "orpos";
    repo = "kaledis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SHjjhPnmovFWem3UEvnldbP/4vhlJqruo9EwDFDiDvM=";
  };

  cargoHash = "sha256-UHUqSuI/r3Fv5Fh1l8u+9QGi73oTut9Ij/G6NGc89FA=";

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
  ];

  env = {
    OPENSSL_NO_VENDOR = "1";
    LIBGIT2_NO_VENDOR = "1";
  };

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
    changelog = "https://github.com/orpos/kaledis/releases/tag/v${finalAttrs.version}";
    mainProgram = "kaledis";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ jerryx77 ];
  };
})
