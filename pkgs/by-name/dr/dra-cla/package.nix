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
  version = "0-unstable-2024-06-07";

  src = fetchFromGitHub {
    owner = "CoolnsX";
    repo = "dra-cla";
    rev = "24d7eaa5d433bc2cbbba4f23552cd812506fefee";
    hash = "sha256-BmBQSkLSq+BaxkzXEy3hlI3qNq2NCIoGKDKt7gyDz+s=";
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
    description = "Cli tool to browse and play korean drama, chinese drama";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ idlip ];
    platforms = platforms.unix;
    mainProgram = "dra-cla";
  };
}
