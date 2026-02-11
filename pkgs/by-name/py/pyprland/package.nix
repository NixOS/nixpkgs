{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pyprland";
  version = "2.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "pyprland";
    tag = finalAttrs.version;
    hash = "sha256-jvdXytMnNrINNkSNljYFS9uomPmQ0g2Bnje/8YbsAv8=";
  };

  nativeBuildInputs = with python3Packages; [ poetry-core ];

  propagatedBuildInputs = with python3Packages; [
    aiofiles
    pillow
  ];
  pythonRelaxDeps = [
    "aiofiles"
  ];

  postInstall = ''
    # file has shebang but cant be run due to a relative import, has proper entrypoint in /bin
    chmod -x $out/${python3Packages.python.sitePackages}/pyprland/command.py
  '';

  # NOTE: this is required for the imports check below to work properly
  HYPRLAND_INSTANCE_SIGNATURE = "dummy";

  pythonImportsCheck = [
    "pyprland"
    "pyprland.adapters"
    "pyprland.adapters.menus"
    "pyprland.command"
    "pyprland.common"
    "pyprland.ipc"
    "pyprland.plugins"
    "pyprland.plugins.experimental"
    "pyprland.plugins.expose"
    "pyprland.plugins.fetch_client_menu"
    "pyprland.plugins.interface"
    "pyprland.plugins.layout_center"
    "pyprland.plugins.lost_windows"
    "pyprland.plugins.magnify"
    "pyprland.plugins.monitors"
    "pyprland.plugins.monitors_v0"
    "pyprland.plugins.pyprland"
    "pyprland.plugins.scratchpads"
    "pyprland.plugins.shift_monitors"
    "pyprland.plugins.shortcuts_menu"
    "pyprland.plugins.system_notifier"
    "pyprland.plugins.toggle_dpms"
    "pyprland.plugins.toggle_special"
    "pyprland.plugins.workspaces_follow_focus"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "pypr";
    description = "Hyperland plugin system";
    homepage = "https://github.com/hyprland-community/pyprland";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      iliayar
      johnrtitor
    ];
    platforms = lib.platforms.linux;
  };
})
