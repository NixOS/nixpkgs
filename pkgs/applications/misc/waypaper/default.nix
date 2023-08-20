{ lib
, python3
, fetchFromGitHub
, gobject-introspection
, gtk3
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "waypaper";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "anufrievroman";
    repo = "waypaper";
    rev = "refs/tags/${version}";
    hash = "sha256-lK4TygR9cwEHcnrC0E5vE7Jor6afEiM9TmEgGXj+hNA=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
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
