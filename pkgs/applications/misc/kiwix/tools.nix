{
  lib,
  docopt_cpp,
  fetchFromGitHub,
  gitUpdater,
  icu,
  libkiwix,
  meson,
  ninja,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kiwix-tools";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "kiwix-tools";
    rev = finalAttrs.version;
    hash = "sha256-fhe3ny4d0RafHiuXKeD1xkIgDZHX8FDwDOLqR0sOZ/o=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    docopt_cpp
    icu
    libkiwix
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Command line Kiwix tools";
    homepage = "https://kiwix.org";
    changelog = "https://github.com/kiwix/kiwix-tools/releases/tag/${finalAttrs.version}";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ colinsane ];
  };
})
