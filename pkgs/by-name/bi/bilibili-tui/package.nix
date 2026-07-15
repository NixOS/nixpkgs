{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
  pkg-config,
  makeBinaryWrapper,
  openssl,
  cacert,
  mpv-unwrapped,
  yt-dlp-light,

  withMpv ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bilibili-tui";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "MareDevi";
    repo = "bilibili-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G2aoPw8SMu3ytHbxcQrf1iH6i+b9viM+/EYorv6j5bg=";
  };

  cargoHash = "sha256-ojAN98of7vZp/F1n0a/88e6k4nBPG9HPKyTO1xc8o4Q=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) pkg-config;

  buildInputs = lib.optional (!stdenv.hostPlatform.isDarwin) openssl;

  env.OPENSSL_NO_VENDOR = true;

  nativeCheckInputs = [ cacert ];

  # Wrap mpv as fallback; users should prefer their system's mpv in PATH
  postInstall = lib.optionalString withMpv ''
    wrapProgram $out/bin/bilibili-tui \
      --suffix PATH : ${
        lib.makeBinPath [
          mpv-unwrapped
          yt-dlp-light
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal user interface (TUI) client for Bilibili";
    homepage = "https://maredevi.moe/projects/bilibili-tui/";
    downloadPage = "https://github.com/MareDevi/bilibili-tui/releases";
    changelog = "https://github.com/MareDevi/bilibili-tui/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puiyq ];
    mainProgram = "bilibili-tui";
  };
})
