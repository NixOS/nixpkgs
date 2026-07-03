{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dezoomify-rs";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "dezoomify-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gx/h9i+VPU0AtpQEkN/zCLmeyaW5wSUCfdY52hPwm3Q=";
  };

  nativeBuildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    pkg-config
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-Jh1a5DW25a4wzuZbOAoTn/crp/ioLsmq3jDiqIctCCM=";

  # hyper uses SystemConfiguration.framework to read system proxy settings.
  # Allow access to the Mach service to prevent the tests from failing.
  sandboxProfile = ''
    (allow mach-lookup (global-name "com.apple.SystemConfiguration.configd"))
  '';

  meta = {
    description = "Zoomable image downloader for Google Arts & Culture, Zoomify, IIIF, and others";
    homepage = "https://github.com/lovasoa/dezoomify-rs/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fsagbuya ];
    mainProgram = "dezoomify-rs";
  };
})
