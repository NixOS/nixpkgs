{
  copyDesktopItems,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  python3,
  xvfb-run,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nexus";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CharaChorder";
    repo = "nexus";
    tag = "v${version}";
    hash = "sha256-Db9XNFRlJ7HgAt57dn2Yhy4HByw9nuQW41oj+4aOPQ0=";
  };

  disabled = python3.pythonOlder "3.11";

  nativeBuildInputs = [
    copyDesktopItems
    python3.pkgs.pyside6-essentials
  ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    cryptography
    pynput
    pyside6-essentials
    pyserial
    requests
  ];

  preBuild =
    let
      sitePackages = "$out/${python3.sitePackages}";
      packageDir = "${sitePackages}/${pname}";
    in
    ''
      mkdir -p ${packageDir}/{translations,ui}

      for file in ui/*.ui; do
        NEW_NAME=$(echo $file | cut --delimiter="." --fields=1).py
        pyside6-uic $file -o ${packageDir}/$NEW_NAME
      done

      mkdir ${sitePackages}/resources_rc
      pyside6-rcc ui/resources.qrc -o ${sitePackages}/resources_rc/__init__.py

      pyside6-lupdate ui/*.ui nexus/GUI.py -ts translations/i18n_en.ts
      for file in translations/*.ts; do
        NEW_NAME=$(echo $file | cut --delimiter="." --fields=1).qm
        pyside6-lrelease $file -qm ${packageDir}/$NEW_NAME
      done
    '';

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp ui/images/icon.svg $out/share/icons/hicolor/scalable/apps/${pname}.svg
  '';

  nativeCheckInputs =
    (with python3.pkgs; [
      flake8
      pytest
      pytest-cov
    ])
    ++ [
      xvfb-run
    ];

  checkPhase = ''
    runHook preCheck

    # The following line tries to access the filesystem:
    # https://github.com/CharaChorder/nexus/blob/v0.5.1/nexus/Freqlog/Definitions.py#L41
    # Imported here:
    # https://github.com/CharaChorder/nexus/blob/v0.5.1/tests/Freqlog/backends/SQLite/test_SQLiteBackend.py#L6
    export HOME=$TMPDIR

    xvfb-run pytest

    runHook postCheck
  '';

  desktopItems = [
    (makeDesktopItem {
      comment = "CharaChorder's all-in-one desktop app";
      desktopName = "Nexus";
      exec = "nexus";
      icon = pname;
      name = pname;
      startupNotify = true;
      startupWMClass = "nexus";
      terminal = false;
      type = "Application";
    })
  ];

  meta = {
    description = "CharaChorder's logging and analysis desktop app";
    downloadPage = "https://github.com/CharaChorder/nexus/releases/tag/${src.tag}";
    homepage = "https://github.com/CharaChorder/nexus/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ getpsyched ];
    mainProgram = "nexus";
    platforms = lib.platforms.linux;
  };
}
