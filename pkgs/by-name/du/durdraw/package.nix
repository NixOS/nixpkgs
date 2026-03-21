{
  lib,
  python3Packages,
  fetchFromGitHub,
  ansilove,
  tzdata,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "durdraw";
  version = "0.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cmang";
    repo = "durdraw";
    tag = finalAttrs.version;
    hash = "sha256-a+4DGWBD5XLaNAfTN/fmI/gALe76SCoWrnjyglNhVPY=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pillow
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ ansilove ]}"
  ];

  nativeCheckInputs =
    (with python3Packages; [
      pytestCheckHook
    ])
    ++ [ tzdata ];

  pytestFlagsArray = [ "test/" ];

  preCheck = ''
    export TZDIR=${tzdata}/share/zoneinfo
  '';

  pythonImportsCheck = [ "durdraw" ];

  meta = {
    description = "ASCII, ANSI and Unicode art editor for Unix terminals with animation support";
    longDescription = ''
      Terminal-based ASCII, ANSI and Unicode art editor for Unix-like systems.
      Supports frame-based animation, custom themes, 256-color and 16-color
      modes, terminal mouse input, IRC color export, Unicode and Code Page 437
      block characters, and PNG/GIF export via ansilove.
    '';
    homepage = "https://durdraw.org";
    changelog = "https://github.com/cmang/durdraw/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rane ];
    mainProgram = "durdraw";
    platforms = lib.platforms.unix;
  };
})
