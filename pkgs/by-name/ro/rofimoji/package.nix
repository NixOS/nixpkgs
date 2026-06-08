{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  stdenv,

  waylandSupport ? (!stdenv.hostPlatform.isDarwin),
  x11Support ? (!stdenv.hostPlatform.isDarwin),

  wl-clipboard,
  wtype,
  xdotool,
  xsel,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rofimoji";
  version = "6.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofimoji";
    tag = finalAttrs.version;
    hash = "sha256-8Y28jlmlKFyqT/OGn/jKjvivMc2U7TQvYmaTX1vCvXQ=";
  };

  nativeBuildInputs = [
    python3Packages.hatchling
    installShellFiles
  ];

  # `rofi` and the `waylandSupport` and `x11Support` dependencies
  # contain binaries needed at runtime.
  propagatedBuildInputs = [
    python3Packages.configargparse
  ]
  ++ lib.optionals waylandSupport [
    wl-clipboard
    wtype
  ]
  ++ lib.optionals x11Support [
    xdotool
    xsel
  ];

  # The 'extractors' sub-module is used for development
  # and has additional dependencies.
  postPatch = ''
    rm -rf extractors
  '';

  postInstall = ''
    installManPage src/picker/docs/rofimoji.1
  '';

  meta = {
    description = "Simple emoji and character picker for rofi";
    mainProgram = "rofimoji";
    homepage = "https://github.com/fdw/rofimoji";
    changelog = "https://github.com/fdw/rofimoji/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ justinlovinger ];
  };
})
