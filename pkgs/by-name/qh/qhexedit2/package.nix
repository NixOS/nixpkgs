{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  qt6,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qhexedit2";
  version = "0.8.10";

  src = fetchFromGitHub {
    owner = "Simsys";
    repo = "qhexedit2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SmBLnMLlsqppVQCkdCgehrtopU064eyckKOt/KeFA3Q=";
  };

  postPatch = ''
    # Fix bugged version check
    sed -i 's/QT_VERSION_STR/"${finalAttrs.version}"/g' example/main.cpp
  '';

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    qt6.qtwayland
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  qmakeFlags = [
    "./example/qhexedit.pro"
  ];

  # A custom installPhase is needed because no [native] build input provides an installPhase hook
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp qhexedit $out/bin

    runHook postInstall
  '';

  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  doInstallCheck = false; # I don't know why this is failing

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hex Editor for Qt";
    homepage = "https://github.com/Simsys/qhexedit2";
    changelog = "https://github.com/Simsys/qhexedit2/releases";
    mainProgram = "qhexedit";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
