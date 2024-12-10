{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapQtAppsHook,
  extra-cmake-modules,
  cmake,
  kio,
  ki18n,
  kxmlgui,
  kconfig,
  karchive,
  kcoreaddons,
  kconfigwidgets,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "mangareader";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "g-fb";
    repo = pname;
    rev = version;
    hash = "sha256-YZZcp+HS/P/GxWYyOpO35nByJSzv4HahzzrZSVRcCRs=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    kio
    ki18n
    kxmlgui
    kconfig
    karchive
    kcoreaddons
    kconfigwidgets
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Qt manga reader for local files";
    homepage = "https://github.com/g-fb/mangareader";
    changelog = "https://github.com/g-fb/mangareader/releases/tag/${src.rev}";
    platforms = platforms.linux;
    license = with licenses; [
      gpl3Plus
      cc-by-nc-sa-40
    ];
    maintainers = with maintainers; [ zendo ];
  };
}
