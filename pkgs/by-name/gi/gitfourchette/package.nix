{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitMinimal,
  qt6,
  imagemagick,
  openssh,
  cacert,
  bash,
  writableTmpDirAsHomeHook,
  hicolor-icon-theme,
  nix-update-script,
  withMfusepy ? true,
}:
with python3Packages;
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gitfourchette";
  version = "1.11.0";
  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jorio";
    repo = "gitfourchette";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vezN3f4o1iviBWKNG2ATRytn9ff9hAIf296cem5GTbs=";
  };

  build-system = [
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

  dependencies = [
    pygit2
    pyqt6
    pygments
  ]
  ++ lib.optional withMfusepy mfusepy;

  nativeCheckInputs = [
    cacert
    gitMinimal
    openssh
    pytestCheckHook
    pytest-qt
    pytest-xdist
    writableTmpDirAsHomeHook
  ];
  enabledTestPaths = [ "test/" ];
  preCheck = ''
    export CI=1
    export QT_QPA_PLATFORM="offscreen"
    export QT_PLUGIN_PATH="${lib.makeSearchPath qt6.qtbase.qtPluginPrefix [ qt6.qtsvg ]}"
  '';

  postPatch = ''
    # Patch inline usage of '/usr/bin/env' for certain tests.
    # When building in the sandbox, /usr/bin/env will not be available.
    substituteInPlace \
      gitfourchette/exttools/toolcommands.py \
      gitfourchette/forms/askpassdialog.py \
      gitfourchette/assets/termcmd.sh \
      test/util.py \
      test/test_tasks_commit.py \
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
