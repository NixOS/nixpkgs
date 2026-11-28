{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  grim,
  hyprland,
  imagemagick,
  jq,
  libxkbcommon,
  systemdMinimal,
  wl-clipboard,
  wtype,
  # hyprctl has to match the compositor that is running, so hypruse uses the
  # one the Hyprland session puts on PATH and Hyprland stays out of the
  # closure. Set this to true to append nixpkgs' hyprctl as a last resort for
  # an MCP client that starts hypruse without the session's PATH.
  withHyprctl ? false,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "hypruse";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IlyasKhallouki";
    repo = "hypruse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-44OdFUWTRmfhLkzoq0CdAvEoelY+zgj8LbAaj5BkEhk=";
  };

  # ctypes.util.find_library finds nothing on NixOS. Without libxkbcommon the
  # keymap stays empty, and typing keys into a background window with
  # Hyprland's sendshortcut then refuses every character
  postPatch = ''
    substituteInPlace src/hypruse/keymap.py \
      --replace-fail 'ctypes.util.find_library("xkbcommon")' \
                     '"${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0"'
  '';

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [ mcp ];

  # appended, not prepended: a grim, wtype or busctl the session already has
  # wins, and these only fill the gaps for a client started with a bare PATH
  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath (
      [
        grim
        imagemagick # numbered marks drawn on screenshots
        systemdMinimal # busctl, for the accessibility tools
        wl-clipboard
        wtype
      ]
      ++ lib.optional withHyprctl hyprland
    ))
  ];

  # the unit tests need no compositor: pyproject.toml's addopts deselects the
  # e2e and background marks, which drive a live Hyprland session
  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    jq # the Waybar module tests
  ];

  pythonImportsCheck = [
    "hypruse"
    "hypruse.server"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "MCP server and CLI that give AI agents control of a Hyprland desktop";
    homepage = "https://github.com/IlyasKhallouki/hypruse";
    changelog = "https://github.com/IlyasKhallouki/hypruse/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ IlyasKhallouki ];
    mainProgram = "hypruse";
    platforms = lib.platforms.linux;
  };
})
