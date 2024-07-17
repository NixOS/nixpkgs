{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  gnugrep,
  gnused,
  curl,
  mpv,
  aria2,
  ffmpeg,
  fzf,
  openssl,
}:

stdenvNoCC.mkDerivation {
  pname = "dra-cla";
  version = "unstable-2024-02-07";

  src = fetchFromGitHub {
    owner = "CoolnsX";
    repo = "dra-cla";
    rev = "cf8a90c0c68338404e8a1434af0a6e65fc5d0a08";
    hash = "sha256-3cz1VeDM0NHdYMiCDVnIq6Y/7rFSijhNrnxC36Yixxc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 dra-cla $out/bin/dra-cla

    wrapProgram $out/bin/dra-cla \
      --prefix PATH : ${
        lib.makeBinPath [
          gnugrep
          gnused
          curl
          mpv
          aria2
          ffmpeg
          fzf
          openssl
        ]
      }

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/CoolnsX/dra-cla";
    description = "A cli tool to browse and play korean drama, chinese drama";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ idlip ];
    platforms = platforms.unix;
    mainProgram = "dra-cla";
  };
}
