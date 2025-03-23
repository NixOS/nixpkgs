{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libsixel,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "presenterm";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    tag = "v${version}";
    hash = "sha256-R2ATN495/sk+EMYs5BBxWk8nLO1ublWKfznn075/V5c=";
  };

  buildInputs = [
    libsixel
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-XXJGduSiPxlmcUyYp8QbTrPYI6NkoYxFA9cfsWgy1Es=";

  checkFlags = [
    # failed to load .tmpEeeeaQ: No such file or directory (os error 2)
    "--skip=external_snippet"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Terminal based slideshow tool";
    changelog = "https://github.com/mfontanini/presenterm/releases/tag/v${version}";
    homepage = "https://github.com/mfontanini/presenterm";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mikaelfangel ];
    mainProgram = "presenterm";
  };
}
