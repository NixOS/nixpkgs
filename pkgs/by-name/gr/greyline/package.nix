{
  lib,
  fetchFromGitHub,
  python3Packages,
  fontconfig,
  nodejs,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "greyline";
  version = "0.8.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Jotham-LEC";
    repo = "greyline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y5quDBb0XiBsLh2PlRvnvrdhrnJo9IPj7FDeYmL4gvU=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pillow
    tomlkit
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ fontconfig ])
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    nodejs
  ];

  pythonImportsCheck = [ "greyline" ];

  meta = {
    description = "Live world-time desktop wallpaper for Wayland and X11";
    longDescription = ''
      A recreation of the IBM/ThinkPad World Time Active Desktop -- A live world-time desktop wallpaper with clocks for your cities, with day/night terminator.
    '';
    homepage = "https://github.com/Jotham-LEC/greyline";
    changelog = "https://github.com/Jotham-LEC/greyline/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ Jotham-LEC ];
    mainProgram = "greyline";
    platforms = lib.platforms.linux;
  };
})
