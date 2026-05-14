{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  autoreconfHook,
  wrapGAppsHook3,
  gtkmm3,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmetronome";
  version = "0.4.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "dqpb";
    repo = "gmetronome";
    rev = finalAttrs.version;
    hash = "sha256-/UWOvVeZILDR29VjBK+mFJt1hzWcOljOr7J7+cMrKtM=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    gtkmm3
    libpulseaudio
  ];

  meta = {
    description = "Free software metronome and tempo measurement tool";
    homepage = "https://gitlab.gnome.org/dqpb/gmetronome";
    changelog = "https://gitlab.gnome.org/dqpb/gmetronome/-/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "gmetronome";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
