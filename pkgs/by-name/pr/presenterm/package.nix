{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libsixel,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "presenterm";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2k1YCzRoXt5Nmn+HH2qkdpP3S3+PJ5OVSVx29nYSdF8=";
  };

  buildInputs = [
    libsixel
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-M9VcwfG6NwUIvOkZKdoh97GVJEivkEmXhlApGQ1Hqds=";

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
