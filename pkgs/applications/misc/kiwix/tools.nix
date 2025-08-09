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
  version = "3.7.0-unstable-2024-12-21";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "kiwix-tools";
    rev = "43b00419dd3f33eb644e1d83c2e802fc200b2de7";
    hash = "sha256-Rctb6ZPTXjgSrLRB5VK4CEqYHuEPB7a+SQaNi47cxv0=";
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ colinsane ];
  };
})
