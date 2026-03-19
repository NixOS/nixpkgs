{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  kdePackages,
  nix-update-script,
  git,
  distrobox,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kontainer";
  version = "1.4.1";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "DenysMb";
    repo = "Kontainer";
    tag = finalAttrs.version;
    hash = "sha256-15H4fTZ4Tja+nt0iKtFuULj/4g/0UK+W79R4kH7BFcs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ (with kdePackages; [
    extra-cmake-modules
    wrapQtAppsHook
  ]);

  buildInputs = [
    git
  ]
  ++ (with kdePackages; [
    qtbase
    qtdeclarative
    kirigami
    kirigami-addons
    ki18n
    kcoreaddons
    qqc2-desktop-style
    kiconthemes
    kio
  ]);

  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ distrobox ]}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Graphical management application for Distrobox containers";
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
      sigmasquadron
    ];
    platforms = lib.platforms.linux;
  };
})
