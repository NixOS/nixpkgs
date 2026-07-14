{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dezoomify-rs";
  version = "2.16.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "dezoomify-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-45Vlgle605s3uvPh+Lr+KAk72AzIoolnSuhFzRCORC4=";
  };

  nativeBuildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    pkg-config
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    openssl
  ];

  nativeCheckInputs = [
    cacert
  ];

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-tfeknHPrY11rSmHyEAUvJgCLDwmIpo9jk8BLgzgQCrc=";

  # hyper uses SystemConfiguration.framework to read system proxy settings.
  # Allow access to the Mach service to prevent the tests from failing.
  sandboxProfile = ''
    (allow mach-lookup (global-name "com.apple.SystemConfiguration.configd"))
  '';

  meta = {
    description = "Zoomable image downloader for Google Arts & Culture, Zoomify, IIIF, and others";
    changelog = "https://github.com/lovasoa/dezoomify-rs/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/lovasoa/dezoomify-rs/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fsagbuya
      kybe236
    ];
    mainProgram = "dezoomify-rs";
  };
})
