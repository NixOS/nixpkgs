{
  python3Packages,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  gobject-introspection,
  v4l-utils,
  wrapGAppsHook3,
  lib,
  fetchpatch,
}:

python3Packages.buildPythonApplication {
  pname = "camset";
  version = "0-unstable-2023-05-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "azeam";
    repo = "camset";
    rev = "b813ba9b1d29f2d46fad268df67bf3615a324f3e";
    hash = "sha256-vTF3MJQi9fZZDlbEj5800H22GGWOte3+KZCpSnsSTaQ=";
  };
  patches = [
    # remove when https://github.com/azeam/camset/pull/30 merged
    (fetchpatch {
      url = "https://github.com/azeam/camset/commit/61e500c661cc6f2d5095a380be719c10c0f77c61.patch";
      name = "fix-numpy-2.3";
      hash = "sha256-FEoxwJSAV/pxtMkCuzdRLjrdbsp7ZNXiMlBtEAK9IJs=";
    })
  ];

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
    copyDesktopItems
  ];

  dependencies = with python3Packages; [
    pygobject3
    opencv-python
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [ v4l-utils ]}
    )
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "camset";
      exec = "camset";
      icon = "camera";
      comment = "Adjust webcam settings";
      desktopName = "Camset";
      categories = [
        "Utility"
        "Video"
      ];
      type = "Application";
    })
  ];

  meta = {
    description = "GUI for Video4Linux adjustments of webcams";
    homepage = "https://github.com/azeam/camset";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ averdow ];
  };
}
