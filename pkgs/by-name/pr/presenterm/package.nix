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
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    tag = "v${version}";
    hash = "sha256-giTEDk5bj1x0cE53zEkQ0SU3SQJZabhr1X3keV07rN4=";
  };

  buildInputs = [
    libsixel
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-N3g7QHgsfr8QH6HWA3/Ar7ZZYN8JPE7D7+/2JVJzW9o=";

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
