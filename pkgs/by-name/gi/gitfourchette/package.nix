{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitMinimal,
  qt6,
  imagemagick,
  cacert,
  bash,
  hicolor-icon-theme,
  nix-update-script,
  withPygments ? true,
  withMfusepy ? true,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gitfourchette";
  version = "1.8.0";
  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jorio";
    repo = "gitfourchette";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GU/Xa9g4DW0npZxNZ4I9vb1ypEqOthSRuZ5Frv4vIrE=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ];
  nativeBuildInputs = [
    imagemagick
    qt6.wrapQtAppsHook
  ];
  propagatedBuildInputs = [ hicolor-icon-theme ];

  dependencies =
    with python3Packages;
    [
      pygit2
      pyqt6
    ]
    ++ lib.optional withPygments pygments
    ++ lib.optional withMfusepy mfusepy;

  nativeCheckInputs = [
    cacert
    gitMinimal
    python3Packages.pytest
    python3Packages.pytest-qt
    python3Packages.pytest-xdist
  ];

  checkPhase = ''
    runHook preCheck
    # Setting CI increases the timeout of some test to 20 seconds.
    export CI=1
    export QT_PLUGIN_PATH="${lib.makeSearchPath qt6.qtbase.qtPluginPrefix [ qt6.qtsvg ]}"
    ${python3Packages.python.interpreter} test.py
    runHook postCheck
  '';

  postPatch = ''
    # Patch inline usage of '/usr/bin/env' for certain tests.
    # When building in the sandbox, /usr/bin/env will not be available.
    substituteInPlace \
      gitfourchette/exttools/toolcommands.py \
      gitfourchette/forms/askpassdialog.py \
      gitfourchette/assets/termcmd.sh \
      --replace-fail '#!/usr/bin/env bash' '#!${bash}/bin/bash'

    patchShebangs update_resources.py test.py test/data
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
    )
  '';

  postInstall = ''
    install -Dm644 pkg/appimage/gitfourchette.desktop \
      $out/share/applications/gitfourchette.desktop

    src_icon=pkg/appimage/gitfourchette.png

    install -Dm644 "$src_icon" \
      $out/share/icons/hicolor/256x256/apps/gitfourchette.png

    for size in 16 22 24 32 48 64 128; do
      install -d $out/share/icons/hicolor/''${size}x''${size}/apps
      magick "$src_icon" -resize ''${size}x''${size} \
        $out/share/icons/hicolor/''${size}x''${size}/apps/gitfourchette.png
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Comfortable Git UI";
    homepage = "https://gitfourchette.org/";
    changelog = "https://github.com/jorio/gitfourchette/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    mainProgram = "gitfourchette";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      _3j14
    ];
    platforms = lib.platforms.linux;
  };
})
