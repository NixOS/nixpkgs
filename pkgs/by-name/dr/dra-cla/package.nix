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
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "CoolnsX";
    repo = "dra-cla";
    # upstream is not tagging releases
    rev = "68e9868354bd9fefa72dbe1e7991bc1f6d184aa2";
    hash = "sha256-CF9XSbkhTrfNE6iR6Q/VWA8x0eDxRKy0Bz0YUuOEEt4=";
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
