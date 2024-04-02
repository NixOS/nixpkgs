{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "pyprland";
  version = "2.1.1";
  format = "pyproject";

  disabled = python3Packages.pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "pyprland";
    rev = "refs/tags/${version}";
    hash = "sha256-S1kNA70kxLK4ZdhJDXp1RhKsGVTS0k9wLxAtndv/iCo=";
  };

  nativeBuildInputs = with python3Packages; [ poetry-core ];

  propagatedBuildInputs = with python3Packages; [ aiofiles ];

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

  meta = with lib; {
    mainProgram = "pypr";
    description = "An hyperland plugin system";
    homepage = "https://github.com/hyprland-community/pyprland";
    license = licenses.mit;
    maintainers = with maintainers; [ iliayar ];
    platforms = platforms.linux;
  };
}
