{ lib
, fetchFromGitHub
, fetchFromGitLab
, gitUpdater
, python3Packages
, blueprint-compiler
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, librsvg
, gtk4
, gtksourceview5
, libadwaita
, cabextract
, p7zip
, xdpyinfo
, imagemagick
, lsb-release
, pciutils
, procps
, gamescope
, mangohud
, vkbasalt-cli
, vmtouch
}:

python3Packages.buildPythonApplication rec {
  pname = "bottles-unwrapped";
  version = "50.2";

  src = fetchFromGitHub {
    owner = "bottlesdevs";
    repo = "bottles";
    rev = version;
    sha256 = "sha256-+r/r3vExnvYQIicKAEmwZ+eRSep6kWte5k7gu9jC67w=";
  };

  patches = [ ./vulkan_icd.patch ];

  # https://github.com/bottlesdevs/Bottles/wiki/Packaging
  nativeBuildInputs = [
    blueprint-compiler
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gtk4 # gtk4-update-icon-cache
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    librsvg
    gtk4
    gtksourceview5
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    pycurl
    pyyaml
    requests
    pygobject3
    patool
    markdown
    fvs
    pefile
    urllib3
    chardet
    certifi
    idna
    pillow
    orjson
    icoextract
  ] ++ [
    cabextract
    p7zip
    xdpyinfo
    imagemagick
    vkbasalt-cli

    gamescope
    mangohud
    vmtouch

    # Undocumented (subprocess.Popen())
    lsb-release
    pciutils
    procps
  ];

  format = "other";
  dontWrapGApps = true; # prevent double wrapping

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "An easy-to-use wineprefix manager";
    homepage = "https://usebottles.com/";
    downloadPage = "https://github.com/bottlesdevs/Bottles/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ psydvl shamilton ];
    platforms = platforms.linux;
  };
}
