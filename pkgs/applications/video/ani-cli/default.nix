{ fetchFromGitHub
, makeWrapper
, stdenvNoCC
, lib
, gnugrep
, gnused
, curl
, fzf
, mpv
, vlc
, iina
, catt
, syncplay
, ffmpeg
, aria2
, player ? "mpv"
, chromecast ? "false"
, sync ? "false"
}:

stdenvNoCC.mkDerivation rec {
  pname = "ani-cli";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ani-cli";
    rev = "v${version}";
    hash = "sha256-XXD55sxgKg8qSdXV7mbnSCQJ4fNgWFG5IiR1QTjDkHI=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ gnugrep gnused curl fzf ffmpeg aria2 ]
                ++ lib.optional (player == "mpv") mpv
                ++ lib.optional (player == "vlc") vlc
                ++ lib.optional (player == "iina") iina
                ++ lib.optional (chromecast != "false") catt
                ++ lib.optional (sync != "false") syncplay;

  installPhase = ''
    install -Dm755 ani-cli $out/bin/ani-cli
    wrapProgram $out/bin/ani-cli \
      --prefix PATH : ${lib.makeBinPath buildInputs}
  '';

  meta = with lib; {
    homepage = "https://github.com/pystardust/ani-cli";
    description = "A cli tool to browse and play anime";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ skykanin ];
    platforms = platforms.unix;
  };
}
