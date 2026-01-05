{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libxcb,
  lndir,
  makeBinaryWrapper,
  spotify,
}:
stdenv.mkDerivation {
  pname = "spotifywm";
  version = "0-unstable-2022-10-25";

  src = fetchFromGitHub {
    owner = "dasJ";
    repo = "spotifywm";
    rev = "8624f539549973c124ed18753881045968881745";
    hash = "sha256-AsXqcoqUXUFxTG+G+31lm45gjP6qGohEnUSUtKypew0=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    lndir
  ];

  buildInputs = [
    libX11
    libxcb
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    lndir -silent ${spotify} $out

    install -Dm644 spotifywm.so $out/lib/spotifywm.so

    wrapProgram $out/bin/spotify \
      --suffix LD_PRELOAD : "$out/lib/spotifywm.so"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/dasJ/spotifywm";
    description = "Wrapper around Spotify that correctly sets class name before opening the window";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      jqueiroz
      the-argus
    ];
    mainProgram = "spotify";
  };
}
