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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "akiirui";
    repo = "mpv-handler";
    tag = "v${version}";
    hash = "sha256-QoctjneJA7CdXqGm0ylAh9w6611vv2PD1fzS0exag5A=";
  };

  cargoHash = "sha256-gKDkDLTLzC53obDd7pORsqP6DhORTbx6tvQ4jq61znQ=";

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
