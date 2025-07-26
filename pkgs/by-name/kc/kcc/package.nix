{
  lib,
  python3,
  fetchFromGitHub,

  qt6,
  archiveSupport ? true,
  p7zip,

  versionCheckHook,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kcc";
  version = "8.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ciromattia";
    repo = "kcc";
    tag = "v${version}";
    hash = "sha256-8rnuSGlfwH5AVp8GQn3RTtiTYFdTNp7Wqq+ATibpkNA=";
  };

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [ qt6.qtbase ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    packaging # undeclared dependency
    pyside6
    pillow
    psutil
    python-slugify
    raven
    requests
    mozjpeg_lossless_optimization
    natsort
    distro
    numpy
  ];

  # Note: python scripts wouldn't get wrapped anyway, but let's be explicit about it
  dontWrapQtApps = true;

  makeWrapperArgs =
    [
      "\${qtWrapperArgs[@]}"
    ]
    ++ lib.optionals archiveSupport [
      ''--prefix PATH : ${lib.makeBinPath [ p7zip ]}''
    ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/kcc-c2e";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Python app to convert comic/manga files or folders to EPUB, Panel View MOBI or E-Ink optimized CBZ";
    homepage = "https://kcc.iosphe.re";
    mainProgram = "kcc";
    changelog = "https://github.com/ciromattia/kcc/releases/tag/v${version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      dawidsowa
      adfaure
    ];
  };
}
