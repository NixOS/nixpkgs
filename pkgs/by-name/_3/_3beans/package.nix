{
  lib,
  stdenv,
  fetchFromGitHub,
  libepoxy,
  wxwidgets_3_3,
  portaudio,
  pkg-config,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "3beans";
  version = "0-unstable-2026-06-17";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Hydr8gon";
    repo = "3Beans";
    rev = "2fc156ca6e2067ac8e66fcb17052f05b163c36d8";
    hash = "sha256-DwzHZ/hM+dJUzKT4DGxD50vK+a54JbYyusO2LtpJATo=";
  };

  nativeBuildInputs = [
    pkg-config
    wxwidgets_3_3
  ];
  buildInputs = [
    libepoxy
    portaudio
  ];

  installPhase = ''
    runHook preInstall
    make install DESTDIR=$out
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Low-level 3DS emulator";
    homepage = "https://github.com/Hydr8gon/3Beans";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "3beans";
    maintainers = with lib.maintainers; [ annoyingrains ];
  };
})
