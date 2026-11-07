{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  openssl,
  pkg-config,
  rustPlatform,
  buildNpmPackage,
  ffmpeg-headless,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxicloud";
  version = "0.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AtalayaLabs";
    repo = "OxiCloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XTZm/uazuRvgwmzD3tg6iC2OlBxJIfFof3NUrjRXYxA=";
  };

  cargoHash = "sha256-4ydOabvaY+bm8Dp5NIpRSnX4ss81rGzOzkmiuS2whEU=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [ openssl ];

  env.OXICLOUD_VERSION = finalAttrs.version;

  postPatch = ''
    # Upstream pins `target-cpu=native`, making the binary non-portable
    # (breaks the binary cache). Build for the generic baseline instead.
    rm -f .cargo/config.toml
  '';

  oxicloud-front = buildNpmPackage (frontFinalAttrs: {
    pname = "oxicloud-front";
    inherit (finalAttrs) version src;
    sourceRoot = "${frontFinalAttrs.src.name}/frontend";

    # vite.config.ts falls back to a build-timestamp, which is not reproducible
    env.OXI_WORKER_VERSION = frontFinalAttrs.version;

    npmDepsHash = "sha256-a0N82bKqP8a1oTRkSxBkiBvW2T+OVsFcnNYuRba5nTk=";

    # The frontend build writes into `../static-dist/`,
    # which is outside of sourceRoot, so make it writable
    postUnpack = ''
      chmod u+w "$sourceRoot/.."
    '';

    installPhase = ''
      runHook preInstall
      cp -r ../static-dist $out
      runHook postInstall
    '';
  });

  postFixup = ''
    wrapProgram $out/bin/oxicloud \
      --set-default OXICLOUD_STATIC_PATH ${finalAttrs.oxicloud-front} \
      --set-default OXICLOUD_FFMPEG_PATH ${lib.getExe' ffmpeg-headless "ffmpeg"}
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "oxicloud-front"
    ];
  };

  meta = {
    description = "Ultra-fast, secure & lightweight self-hosted cloud storage";
    homepage = "https://github.com/AtalayaLabs/OxiCloud";
    changelog = "https://github.com/AtalayaLabs/OxiCloud/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "oxicloud";
    maintainers = with lib.maintainers; [ flashonfire ];
    platforms = lib.platforms.linux;
  };
})
