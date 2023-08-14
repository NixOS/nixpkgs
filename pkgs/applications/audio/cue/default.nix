{ lib
, stdenv
, fetchFromGitHub
, chafa
, ffmpeg
, fftwFloat
, freeimage
, glib
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cue";
  version = "0.9.18";

  src = fetchFromGitHub {
    owner = "ravachol";
    repo = "cue";
    rev = "v${finalAttrs.version}";
    hash = "sha256-coW9tATbUX6Pi+fFFQ+7J0QuNyQo55ajSrGkKsqZGjg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    chafa
    ffmpeg
    fftwFloat
    freeimage
    glib
  ];

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin cue

    runHook postInstall
  '';

  meta = {
    description = "A command-line music player";
    homepage = "https://github.com/ravachol/cue";
    license = lib.licenses.gpl2Plus;
    mainProgram = "cue";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
