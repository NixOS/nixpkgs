{
  lib,
  fetchFromGitHub,
  python3Packages,
  blueprint-compiler,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  librsvg,
  gtk4,
  gtksourceview5,
  libadwaita,
  cabextract,
  p7zip,
  xdpyinfo,
  imagemagick,
  lsb-release,
  pciutils,
  procps,
  gamescope,
  mangohud,
  vkbasalt-cli,
  vmtouch,
  libportal,
  nix-update-script,
  removeWarningPopup ? false,
}:

python3Packages.buildPythonApplication rec {
  pname = "bottles-unwrapped";
  version = "51.21";

  src = fetchFromGitHub {
    owner = "bottlesdevs";
    repo = "bottles";
    tag = version;
    hash = "sha256-rUS2LRr7NqTvNd706AC/U/QUDcF8tzwkHDuS3R0O1KY=";
  };

  patches =
    [
      ./vulkan_icd.patch
      ./redirect-bugtracker.patch
      ./remove-flatpak-check.patch
    ]
    ++ (
      if removeWarningPopup then
        [ ./remove-unsupported-warning.patch ]
      else
        [
          ./warn-unsupported.patch
        ]
    );

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
    libportal
  ];

  propagatedBuildInputs =
    with python3Packages;
    [
      pyyaml
      pycurl
      chardet
      requests
      markdown
      icoextract
      patool
      pathvalidate
      fvs
      orjson
      pycairo
      pygobject3
      charset-normalizer
      idna
      urllib3
      certifi
      pefile
    ]
    ++ [
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy-to-use wineprefix manager";
    homepage = "https://usebottles.com/";
    downloadPage = "https://github.com/bottlesdevs/Bottles/releases";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      psydvl
      shamilton
      Gliczy
      XBagon
    ];
    platforms = lib.platforms.linux;
    mainProgram = "bottles";
  };
}
