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
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    tag = "v${version}";
    hash = "sha256-ow87vKHfdstL2k73wHD06HsX28mLvTrWh5yIbo/a54M=";
  };

  buildInputs = [
    libsixel
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-KpwW2lblX4aCN73jWFY9Ylp+AEbGWCu/jb/c8wTao08=";

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
