{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "hyprconf2lua";
  version = "1.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Prateek-squadron";
    repo = "hyprconf2lua";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JLkUsJ+2L4KxM9v3V56IP9JKgRcOKW2V8XsSHUecDfI=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  optional-dependencies = with python3Packages; {
    dev = [
      pytest
    ];
  };

  pythonImportsCheck = [
    "hyprconf2lua"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convert Hyprland .conf to Lua for v0.55+ — drop-in replacement for deprecated hyprlang. ~97% auto-conversion, 0% guesswork";
    homepage = "https://github.com/Prateek-squadron/hyprconf2lua";
    changelog = "https://github.com/Prateek-squadron/hyprconf2lua/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dwoffinden ];
    mainProgram = "hyprconf2lua";
  };
})
