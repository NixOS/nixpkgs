{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  pkg-config,
  kdePackages,
  ffmpeg,
  sdl3,
  kissfft,
  kissfftFloat,
  libcdio,
  pipewire,
  libpulseaudio,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dragon-media-backend";
  version = "0.90.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "dragon-media-backend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZLCv1Z9WyOopo3BVFqRzQCyguOg5zXOMAWU9MDSgpyo=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.kio
    ffmpeg
    kdePackages.qcoro
    sdl3
    kissfft
    kissfftFloat
    kdePackages.libkcddb
    libcdio
    pipewire
    libpulseaudio
  ];

  dontWrapQtApps = true;
  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Qt C++ library intended for desktop music players";
    homepage = "https://invent.kde.org/libraries/dragon-media-backend";
    donationPage = "https://kde.org/donate/";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.coca ];
    # Licenses referenced from `reuse lint`
    license =
      with lib.licenses;
      AND [
        (OR [
          lgpl21Only
          lgpl3Only
          # pkgs/kde/lib/mk-kde-derivation.nix uses this for LicenseRef-KDE-Accepted-LGPL
          lgpl3Plus
        ])
        bsd3
        cc-by-30
        cc-by-sa-40
        cc0
        mit
        zlib
      ];
  };
})
