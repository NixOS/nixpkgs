{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6,
  kdePackages,
  nix-update-script,
  translate-shell,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "klaro";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "DenysMb";
    repo = "Klaro";
    tag = finalAttrs.version;
    hash = "sha256-XBoHWXq0F4jAFVbRUBWoDAPKgN24Z+08EKi4y39g9us=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "ecm_find_qmlmodule(org.kde.kirigami REQUIRED)" "ecm_find_qmlmodule(org.kde.kirigami)"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.ki18n
    kdePackages.kcoreaddons
    kdePackages.qqc2-desktop-style
    kdePackages.kiconthemes
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        translate-shell
      ]
    }"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple and fast translation app for KDE Plasma";
    longDescription = ''
      A simple and fast translation app for KDE Plasma that helps you translate text between different languages.
    '';
    homepage = "https://github.com/DenysMb/Klaro";
    changelog = "https://github.com/DenysMb/Klaro/releases/tag/${finalAttrs.version}";
    mainProgram = "klaro";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
    platforms = lib.platforms.linux;
  };
})
