{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "open-numismat";
  version = "1.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenNumismat";
    repo = "open-numismat";
    tag = finalAttrs.version;
    hash = "sha256-nt+vFtYMd6nR/ZOGUeXQCMOG/dv6tRYuo0/mcb4swdM=";
    fetchSubmodules = true;
  };

  __structuredAttrs = true;

  build-system = [
    python3.pkgs.setuptools
  ];

  dependencies =
    with python3.pkgs;
    [
      imagehash
      jinja2
      lxml
      numpy
      opencv-python-headless
      openpyxl
      pillow
      pyside6
      python-dateutil
      rembg
      scipy
      urllib3
      zxing-cpp
    ]
    ++ lib.optionals stdenv.hostPlatform.isWindows [
      pywin32
    ];

  pythonImportsCheck = [
    "OpenNumismat"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "intended primarily for registering a collection of coins, but also suitable for other types of collectibles";
    homepage = "https://opennumismat.github.io";
    changelog = "https://opennumismat.github.io/open-numismat/history.html";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "open-numismat";
  };
})
