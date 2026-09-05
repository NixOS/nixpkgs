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
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "MareDevi";
    repo = "bilibili-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DKcjIPBNAA2iUO7Evfn6muZpOB8pUEmLCr3oEd/A6io=";
  };

  cargoHash = "sha256-YxCvFCRtnIUxXgZWBvhKnjeth8TX+3iHcOxPQX8d6Ck=";

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
