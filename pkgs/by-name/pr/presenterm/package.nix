{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  lld,
  libsixel,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "presenterm";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vBEHk0gQe4kUTtH4qtc0jVfDvYGabnkJrwPxmxt10hs=";
  };

  nativeBuildInputs = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    lld
  ];

  buildInputs = [
    libsixel
  ];

  buildFeatures = [
    "sixel"
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-u0wOWKAfzi1Fxmx6x2ckrIv/PKgtqKrDiDauD4/BY24=";

  env = lib.optionalAttrs (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) {
    NIX_CFLAGS_LINK = "-fuse-ld=lld";
  };

  checkFeatures = [
    "sixel"
  ];

  checkFlags = [
    # failed to load .tmpEeeeaQ: No such file or directory (os error 2)
    "--skip=external_snippet"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Terminal based slideshow tool";
    changelog = "https://github.com/mfontanini/presenterm/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/mfontanini/presenterm";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mikaelfangel ];
    mainProgram = "presenterm";
  };
})
