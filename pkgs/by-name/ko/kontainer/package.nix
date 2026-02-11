{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6,
  kdePackages,
  nix-update-script,
  git,
  distrobox,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kontainer";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "DenysMb";
    repo = "Kontainer";
    tag = finalAttrs.version;
    hash = "sha256-fHXpbQyNEX7jO+v81dVhGodlJ4OrbPn53mgAJbCiyWw=";
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

  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        distrobox
      ]
    }"
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
    kdePackages.kio
    git
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage Distrobox containers";
    longDescription = ''
      Kontainer is a graphical user interface (GUI) application built with KDE Kirigami that provides a user-friendly way to manage Distrobox containers.

      *Container Management*: Create new containers from various Linux distributions, delete existing containers, upgrade containers and list and view all containers.

      *Terminal Integration*: Open terminal sessions inside containers using the system default terminal emulator and execute commands within containers.

      *Package Management*: Install package files inside containers and automatic detection of appropriate package managers based on container distribution.

      *Desktop Integration*: Generate desktop shortcuts for containers, full integration with the host system through Distrobox and color-coded container listing based on distribution.
    '';
    homepage = "https://github.com/DenysMb/Kontainer";
    changelog = "https://github.com/DenysMb/Kontainer/releases/tag/${finalAttrs.version}";
    mainProgram = "kontainer";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
    platforms = lib.platforms.linux;
  };
})
