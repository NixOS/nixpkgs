{
  fetchFromGitHub,
  makeWrapper,
  stdenvNoCC,
  lib,
  gnugrep,
  gnused,
  curl,
  catt,
  syncplay,
  ffmpeg,
  fzf,
  aria2,
  withMpv ? true,
  mpv,
  withVlc ? false,
  vlc,
  withIina ? false,
  iina,
  chromecastSupport ? false,
  syncSupport ? false,
}:

assert withMpv || withVlc || withIina;

stdenvNoCC.mkDerivation rec {
  pname = "ani-cli";
  version = "4.8";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ani-cli";
    rev = "v${version}";
    hash = "sha256-vntCiWaONndjU622c1BoCoASQxQf/i7yO0x+70OxzPU=";
  };

  nativeBuildInputs = [ makeWrapper ];
  runtimeDependencies =
    let
      player = [ ] ++ lib.optional withMpv mpv ++ lib.optional withVlc vlc ++ lib.optional withIina iina;
    in
    [
      gnugrep
      gnused
      curl
      fzf
      ffmpeg
      aria2
    ]
    ++ player
    ++ lib.optional chromecastSupport catt
    ++ lib.optional syncSupport syncplay;

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
    mainProgram = "ani-cli";
  };
}
