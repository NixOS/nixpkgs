{ stdenv, fetchFromGitHub, spotify, xorg, runtimeShell }:
stdenv.mkDerivation {
  pname = "spotifywm-unstable";
  version = "2016-11-28";

  src = fetchFromGitHub {
    owner  = "dasJ";
    repo   = "spotifywm";
    rev    = "91dd5532ffb7a398d775abe94fe7781904ab406f";
    sha256 = "01z088i83410bpx1vbp7c6cq01r431v55l7340x3izp53lnpp379";
  };

  buildInputs = [ xorg.libX11 ];

  propagatedBuildInputs = [ spotify ];

  installPhase = ''
    echo "#!${runtimeShell}" > spotifywm
    echo "LD_PRELOAD="$out/lib/spotifywm.so" ${spotify}/bin/spotify \$*" >> spotifywm
    install -Dm644 spotifywm.so $out/lib/spotifywm.so
    install -Dm755 spotifywm $out/bin/spotifywm
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/dasJ/spotifywm;
    description = "Wrapper around Spotify that correctly sets class name before opening the window";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jqueiroz ];
  };
}
