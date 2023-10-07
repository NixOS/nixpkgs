{ lib, stdenv, fetchFromGitHub, spotify, xorg, makeWrapper }:
stdenv.mkDerivation {
  pname = "spotifywm-unstable";
  version = "2022-10-26";

  src = fetchFromGitHub {
    owner = "dasJ";
    repo = "spotifywm";
    rev = "8624f539549973c124ed18753881045968881745";
    sha256 = "sha256-AsXqcoqUXUFxTG+G+31lm45gjP6qGohEnUSUtKypew0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ xorg.libX11 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    install -Dm644 spotifywm.so $out/lib/
    ln -sf ${spotify}/bin/spotify $out/bin/spotify

    # wrap spotify to use spotifywm.so
    wrapProgram $out/bin/spotify --set LD_PRELOAD "$out/lib/spotifywm.so"
    # backwards compatibility for people who are using the "spotifywm" binary
    ln -sf $out/bin/spotify $out/bin/spotifywm

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dasJ/spotifywm";
    description = "Wrapper around Spotify that correctly sets class name before opening the window";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jqueiroz the-argus ];
  };
}
