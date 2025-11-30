{
  lib,
  python3,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,

  qt6,
  archiveSupport ? true,
  p7zip,

  versionCheckHook,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kcc";
  version = "9.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ciromattia";
    repo = "kcc";
    tag = "v${version}";
    hash = "sha256-1qm8kKCYy3GE562EzDKepOaUJZr15o1ATQ9C+vwrDh0=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
  ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    packaging # undeclared dependency
    pymupdf
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

  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
  ]
  ++ lib.optionals archiveSupport [
    ''--prefix PATH : ${lib.makeBinPath [ p7zip ]}''
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/kcc-c2e";

  postInstall = ''
    install -Dm644 \
      icons/comic2ebook.png \
      "$out/share/icons/hicolor/256x256/apps/kcc.png"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  desktopItems = [
    (makeDesktopItem {
      name = "kcc";
      exec = "kcc";
      icon = "kcc";
      desktopName = "Kindle Comic Converter";
      comment = "A comic and manga converter for ebook readers";
      categories = [ "Graphics" ];
    })
  ];

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
