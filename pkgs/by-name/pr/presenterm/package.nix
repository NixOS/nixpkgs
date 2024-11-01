{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libsixel,
  stdenv,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "presenterm";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    rev = "refs/tags/v${version}";
    hash = "sha256-BFL0Y6v1v15WLSvA5i+l47bR9+1qDHPWSMMuEaLdhPY=";
  };

  buildInputs = [
    libsixel
  ];

  cargoHash = "sha256-IC72l1xbH/AdCHdcgY8ODv6+YZUmT5NYVisP9oIMpGA=";

  # Crashes at runtime on darwin with:
  # Library not loaded: .../out/lib/libsixel.1.dylib
  buildFeatures = lib.optionals (!stdenv.hostPlatform.isDarwin) [ "sixel" ];

  checkFlags = [
    # failed to load .tmpEeeeaQ: No such file or directory (os error 2)
    "--skip=external_snippet"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  meta = {
    description = "Terminal based slideshow tool";
    changelog = "https://github.com/mfontanini/presenterm/releases/tag/v${version}";
    homepage = "https://github.com/mfontanini/presenterm";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mikaelfangel ];
    mainProgram = "presenterm";
  };
}
