{ fetchFromGitHub
, makeWrapper
, stdenvNoCC
, lib
, gnugrep
, gnused
<<<<<<< HEAD
, curl
, catt
, syncplay
, ffmpeg
, fzf
, aria2
, withMpv ? true, mpv
, withVlc ? false, vlc
, withIina ? false, iina
, chromecastSupport ? false
, syncSupport ? false
}:

assert withMpv || withVlc || withIina;

stdenvNoCC.mkDerivation rec {
  pname = "ani-cli";
  version = "4.6";
=======
, wget
, fzf
, mpv
, aria2
}:

stdenvNoCC.mkDerivation rec {
  pname = "ani-cli";
  version = "4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ani-cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ahyCD4QsYyb3xtNK03HITeF0+hJFIHZ+PAjisuS/Kdo=";
  };

  nativeBuildInputs = [ makeWrapper ];
  runtimeDependencies =
    let player = []
        ++ lib.optional withMpv mpv
        ++ lib.optional withVlc vlc
        ++ lib.optional withIina iina;
    in [ gnugrep gnused curl fzf ffmpeg aria2 ]
      ++ player
      ++ lib.optional chromecastSupport catt
      ++ lib.optional syncSupport syncplay;
=======
    hash = "sha256-XXD55sxgKg8qSdXV7mbnSCQJ4fNgWFG5IiR1QTjDkHI=";
  };

  nativeBuildInputs = [ makeWrapper ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  installPhase = ''
    runHook preInstall

    install -Dm755 ani-cli $out/bin/ani-cli

    wrapProgram $out/bin/ani-cli \
<<<<<<< HEAD
      --prefix PATH : ${lib.makeBinPath runtimeDependencies}
=======
      --prefix PATH : ${lib.makeBinPath [ gnugrep gnused wget fzf mpv aria2 ]}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/pystardust/ani-cli";
    description = "A cli tool to browse and play anime";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ skykanin ];
    platforms = platforms.unix;
  };
}
