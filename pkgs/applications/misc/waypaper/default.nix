{ lib
, python3
, fetchFromGitHub
, gobject-introspection
, wrapGAppsHook3
, killall
}:

python3.pkgs.buildPythonApplication rec {
  pname = "waypaper";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "anufrievroman";
    repo = "waypaper";
    rev = "refs/tags/${version}";
    hash = "sha256-GB+H2kZr1+UhhGFpfXc3V4DPXjvHBdg6EKNEFhjKEHk=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    python3.pkgs.pygobject3
    python3.pkgs.platformdirs
    python3.pkgs.importlib-metadata
    python3.pkgs.pillow
    killall
  ];

  # has no tests
  doCheck = false;

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    changelog = "https://github.com/anufrievroman/waypaper/releases/tag/${version}";
    description = "GUI wallpaper setter for Wayland-based window managers";
    mainProgram = "waypaper";
    longDescription = ''
      GUI wallpaper setter for Wayland-based window managers that works as a frontend for popular backends like swaybg and swww.

      If wallpaper does not change, make sure that swaybg or swww is installed.
    '';
    homepage = "https://github.com/anufrievroman/waypaper";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ totalchaos ];
    platforms = platforms.linux;
  };
}
