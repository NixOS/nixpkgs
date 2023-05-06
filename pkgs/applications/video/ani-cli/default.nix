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
, chromecastSupport ? false
, sync ? false
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
  runtimeDependencies = [ gnugrep gnused curl fzf ffmpeg aria2 ]
    ++ lib.optional (player == "mpv")
    ++ lib.optional (player == "vlc") vlc 
    ++ lib.optional (player == "iina") iina
    ++ lib.optional chromecastSupport catt
    ++ lib.optional sync syncplay;

  installPhase = ''
    runHook preInstall
    
    install -Dm755 ani-cli $out/bin/ani-cli
    
    wrapProgram $out/bin/ani-cli \
      --prefix PATH : ${lib.makeBinPath runtimeDependencies}
      
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
