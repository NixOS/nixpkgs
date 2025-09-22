{
  # Derivation stuff
  fetchFromGitHub,
  lib,
  makeWrapper,
  stdenv,
  # Dependencies
  # Add these to the wrapper
  curl,
  gawk,
  gnugrep,
  gnused,
  socat,
  wget,
}:
stdenv.mkDerivation {
  pname = "simple-dlna-browser";
  version = "0-unstable-2023-01-09";

  src = fetchFromGitHub {
    owner = "javier-lopez";
    repo = "learn";
    sparseCheckout = [
      "sh/tools/simple-dlna-browser"
    ];
    rev = "666e2c402723251ba19ce9d7c11b83b06c15a2c5";
    hash = "sha256-jwPAEgti5DrjNnNVW/61GGTP+QedGAjz9kPwYhMAdTk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    outputWrapper="$out/bin/simple-dlna-browser"
    outputWrapped="$out/bin/wrapped-simple-dlna-browser"

    mkdir -p $out/bin
    cp sh/tools/simple-dlna-browser $outputWrapped
    makeWrapper $outputWrapped $outputWrapper \
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          gawk
          gnugrep
          gnused
          socat
          wget
        ]
      }

    # Set the program name to a fixed value
    # Normally it is guessed by the filename, but we don't want it to be the name of the wrapper
    sed -i -e 's/PROGNAME=".*"/PROGNAME="simple-dlna-browser"/' $outputWrapped
  '';

  meta = {
    description = "Query dlna media servers";
    longDescription = ''
      A bash script that allows simple interactions with [DLNA] media servers.
      It is a light-weight, CLI alternative to [VLC], [Kodi], and other players.

      [DLNA]: https://en.wikipedia.org/wiki/Digital_Living_Network_Alliance
      [Kodi]: https://kodi.tv/
      [VLC]: https://www.videolan.org/vlc/
    '';
    homepage = "https://github.com/javier-lopez/learn/blob/master/sh/tools/simple-dlna-browser";
    license = lib.licenses.fair;
    maintainers = with lib.maintainers; [ ];
  };
}
