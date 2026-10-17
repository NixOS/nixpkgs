{
  lib,
  python3,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  qt6,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "leshade";
  version = "2.4.7";
  __structuredAttrs = true;

  pyproject = false;

  src = fetchFromGitHub {
    owner = "Ishidawg";
    repo = "LeShade";
    tag = finalAttrs.version;
    hash = "sha256-whv+pTi7b1yrRP4TIrbj7JKDF3jGmDFviQwm70gu6EQ=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyside6
    certifi
  ];

  makeWrapperArgs = [
    "--prefix"
    "PYTHONPATH"
    ":"
    (placeholder "out" + "/share/leshade")
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postInstall = ''
    rm $out/bin/leshade
    cp $out/share/leshade/main.py $out/bin/leshade
    chmod +x $out/bin/leshade

    substituteInPlace $out/share/applications/leshade.desktop \
      --replace-fail "Icon=io.github.ishidawg.LeShade" "Icon=leshade"
  '';

  meta = {
    description = "ReShade manager for Linux";
    mainProgram = "leshade";
    homepage = "https://github.com/Ishidawg/LeShade";
    changelog = "https://github.com/Ishidawg/LeShade/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amadejkastelic ];
    platforms = lib.platforms.linux;
  };
})
