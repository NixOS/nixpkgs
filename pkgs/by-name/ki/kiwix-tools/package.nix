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
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "kiwix-tools";
    tag = finalAttrs.version;
    hash = "sha256-lq7pP9ftRe26EEVntdY9xs951mvrvUKMMep/Oup4jdE=";
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

  meta = {
    description = "Command line Kiwix tools";
    homepage = "https://kiwix.org";
    changelog = "https://github.com/kiwix/kiwix-tools/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ colinsane ];
  };
})
