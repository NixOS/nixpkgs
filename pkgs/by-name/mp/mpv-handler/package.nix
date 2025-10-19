{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  mpv,
  yt-dlp,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "mpv-handler";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "akiirui";
    repo = "mpv-handler";
    tag = "v${version}";
    hash = "sha256-uWV9pjZp5s8H1UDS/T0JK//eJNnsaaby88l/tDqlQHY=";
  };

  cargoHash = "sha256-Cps+cPOv8uV8x0MiBdSqsdJ/8n259K6Y5aVl2aWJ/tE=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    install -Dm644 share/linux/mpv-handler.desktop -t $out/share/applications/
    install -Dm644 share/linux/mpv-handler-debug.desktop -t $out/share/applications/
    install -Dm644 share/linux/config.toml -t $out/share/doc/mpv-handler/

    wrapProgram $out/bin/mpv-handler \
      --prefix PATH : ${
        lib.makeBinPath [
          mpv
          yt-dlp
        ]
      }
  '';

  meta = {
    description = "Play website videos and songs with mpv & yt-dlp";
    homepage = "https://github.com/akiirui/mpv-handler";
    mainProgram = "mpv-handler";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lonerOrz ];
    platforms = lib.platforms.linux;
  };
}
