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
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "bottles-unwrapped";
  version = "51.15";

  src = fetchFromGitHub {
    owner = "bottlesdevs";
    repo = "bottles";
    rev = "refs/tags/${version}";
    hash = "sha256-HjGAeIh9s7xWBy35Oj66tCtgKCd/DpHg1sMPsdjWKDs=";
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

  propagatedBuildInputs =
    with python3Packages;
    [
      pathvalidate
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
      orjson
      icoextract
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
    ];
    platforms = lib.platforms.linux;
    mainProgram = "bottles";
  };
}
