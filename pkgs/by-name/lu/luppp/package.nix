{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  jack2,
  cairo,
  liblo,
  libsndfile,
  libsamplerate,
  ntk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "luppp";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "openAVproductions";
    repo = "openAV-Luppp";
    rev = "release-${finalAttrs.version}";
    sha256 = "1ncbn099fyfnr7jw2bp3wf2g9k738lw53m6ssw6wji2wxwmghv78";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    jack2
    cairo
    liblo
    libsndfile
    libsamplerate
    ntk
  ];

  meta = {
    homepage = "http://openavproductions.com/luppp/"; # https does not work
    description = "Music creation tool, intended for live use";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ prusnak ];
    platforms = lib.platforms.linux;
    mainProgram = "luppp";
  };
})
