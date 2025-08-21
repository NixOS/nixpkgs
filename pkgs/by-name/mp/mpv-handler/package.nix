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
  version = "0.3.16";

  src = fetchFromGitHub {
    owner = "akiirui";
    repo = "mpv-handler";
    tag = "v${version}";
    hash = "sha256-RpfHUVZmhtneeu8PIfxinYG3/groJPA9QveDSvzU6Zo=";
  };

  cargoHash = "sha256-FrE1PSRc7GTNUum05jNgKnzpDUc3FiS5CEM18It0lYY=";

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
