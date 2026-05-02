{
  lib,
  rustPlatform,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  libgit2,
  openssl,
  stdenv,
  zlib,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghr";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "siketyan";
    repo = "ghr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8DnujtAtJiSnrC3k5vGRQuk6RfC5Vn+z4HAVsEnXN7c=";
  };

  cargoHash = "sha256-8b9kAl9KoeWG+LEFkRQd6zbiWqyIybbcXpImz+akS7M=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
    zstd
  ];

  postInstall =
    let
      ghr = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/ghr";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      installShellCompletion --cmd ghr \
        --bash <(${ghr} shell --completion bash) \
        --fish <(${ghr} shell --completion fish)
    '';

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Yet another repository management with auto-attaching profiles";
    homepage = "https://github.com/siketyan/ghr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sei40kr ];
    mainProgram = "ghr";
  };
})
