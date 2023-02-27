{ lib, stdenv, fetchFromGitHub, spotify, xorg, runtimeShell }:
stdenv.mkDerivation {
  pname = "spotifywm-unstable";
  version = "2022-10-26";

  src = fetchFromGitHub {
    owner = "dasJ";
    repo = "spotifywm";
    rev = "8624f539549973c124ed18753881045968881745";
    sha256 = "sha256-AsXqcoqUXUFxTG+G+31lm45gjP6qGohEnUSUtKypew0=";
  };

  buildInputs = [ xorg.libX11 ];

  propagatedBuildInputs = [ spotify ];

  installPhase = ''
    echo "#!${runtimeShell}" > spotifywm
    echo "LD_PRELOAD="$out/lib/spotifywm.so" ${spotify}/bin/spotify \$*" >> spotifywm
    install -Dm644 spotifywm.so $out/lib/spotifywm.so
    install -Dm755 spotifywm $out/bin/spotifywm
  '';

  meta = with lib; {
    homepage = "https://github.com/dasJ/spotifywm";
    description = "Wrapper around Spotify that correctly sets class name before opening the window";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jqueiroz ];
  };
}
