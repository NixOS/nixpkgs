{
  lib,
  python3Packages,
  fetchFromGitHub,
  desktop-file-utils,
  glib,
  gobject-introspection,
  gtk4,
  libadwaita,
  librsvg,
  shared-mime-info,
  wrapGAppsHook4,
  xvfb-run,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rayforge";
  version = "1.11.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "barebaric";
    repo = "rayforge";
    tag = finalAttrs.version;
    hash = "sha256-7aWfU73PipmHkovCZEyBIK+CV3PAGGP/yKmTaYnDqrY=";
  };

  # setuptools-git-versioning derives the version from a git repository, which
  # the release tarball does not carry, so hardcode it instead.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools >= 40.9.0", "setuptools-git-versioning"' '"setuptools >= 40.9.0"' \
      --replace-fail 'dynamic = ["version", "dependencies"]' 'version = "${finalAttrs.version}"
    dynamic = ["dependencies"]'
  '';

  # requirements.txt pins every dependency to an exact version.
  pythonRelaxDeps = true;

  # cv2 comes from opencv4, whose dist-info is named "opencv". Spelled with an
  # underscore to match requirements.txt verbatim: the hook greps Requires-Dist
  # literally and does not normalise the name.
  pythonRemoveDeps = [ "opencv_python" ];

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    shared-mime-info
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
  ];

  dependencies = with python3Packages; [
    aiohttp
    asyncudp
    blinker
    ezdxf
    gitpython
    numpy
    opencv4
    platformdirs
    pluggy
    pycairo
    pygobject3
    pymupdf
    pyopengl
    pyopengl-accelerate
    pypdf
    pyserial
    pyvips
    pyyaml
    raygeo
    ruida-pa
    scipy
    semver
    svgelements
    trimesh
    vtracer
    websockets
    zeroconf
  ];

  nativeCheckInputs = [
    xvfb-run
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ]);

  # rayforge.config creates its log and config directories at import time.
  preCheck = ''
    export HOME=$(mktemp -d)
    export GSK_RENDERER=cairo
  '';

  checkPhase = ''
    runHook preCheck
    xvfb-run -s '-screen 0 1280x1024x24' pytest
    runHook postCheck
  '';

  # Upstream's addopts already excludes the "ui" and "stress" marks, which need
  # a graphical environment and a real GTK event loop.

  pythonImportsCheck = [ "rayforge" ];

  # Prevent double wrapping.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "2D CAD and G-code sender for laser cutters and engravers";
    homepage = "https://github.com/barebaric/rayforge";
    changelog = "https://github.com/barebaric/rayforge/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "rayforge";
    maintainers = with lib.maintainers; [ kanagawamarcos ];
    platforms = lib.platforms.linux;
  };
})
