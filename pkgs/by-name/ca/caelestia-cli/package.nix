{
  lib,
  python3,
  fetchFromGitHub,
  installShellFiles,
  swappy,
  libnotify,
  slurp,
  wl-clipboard,
  cliphist,
  xdg-utils,
  dart-sass,
  grim,
  fuzzel,
  gpu-screen-recorder,
  dconf,
  killall,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "caelestia-cli";
  __structuredAttrs = true;
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "caelestia-dots";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-cCP6RAEh6JliKFmvtgi97uIG1dH0lIIuDNAdrdX+1U0=";
  };

  pyproject = true;

  build-system = with python3.pkgs; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python3.pkgs; [
    materialyoucolor
    pillow
  ];

  pythonImportsCheck = [ "caelestia" ];

  nativeBuildInputs = [ installShellFiles ];

  runtimeDeps = [
    swappy
    libnotify
    slurp
    wl-clipboard
    cliphist
    xdg-utils
    dart-sass
    grim
    fuzzel
    gpu-screen-recorder
    dconf
    killall
  ];

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    "${lib.makeBinPath runtimeDeps}"
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace src/caelestia/subcommands/{shell.py,screenshot.py} \
        --replace-fail '"qs", "-c", "caelestia"' '"caelestia-shell"'

    substituteInPlace src/caelestia/subcommands/toggle.py \
        --replace-fail '["todoist"]' '["todoist.desktop"]'
  '';

  postInstall = ''
    installShellCompletion completions/caelestia.fish
  '';

  meta = {
    description = "The main control script for the Caelestia Shell";
    homepage = "https://github.com/caelestia-dots/cli";
    license = lib.licenses.gpl3Only;
    mainProgram = "caelestia";
    maintainers = with lib.maintainers; [ rachalaraj ];
    platforms = lib.platforms.linux;
  };
}
