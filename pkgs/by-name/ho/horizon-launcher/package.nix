{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  jdk25,
  openssl,
  alsa-lib,
  systemd,
  fontconfig,
  freetype,
  libGL,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "horizon-launcher";
  version = "0.2.36";

  __structuredAttrs = true;

  env = {
    # launcher/Cargo.toml is not bumped every release; CI sets these at compile time (launcher.yml).
    HORIZON_LAUNCHER_VERSION = finalAttrs.version;
    HORIZON_LAUNCHER_TAG = "launcher@${finalAttrs.version}";
    # Public Azure app id (docs/microsoft-account.md); empty build cannot sign in to Microsoft.
    HORIZON_MSA_CLIENT_ID = "331e08f8-172d-43b9-835a-3108c2fcdbf3";
  };

  src = fetchFromGitHub {
    owner = "horizon-rust";
    repo = "horizon";
    tag = "launcher@${finalAttrs.version}";
    hash = "sha256-RcstuW4C3qnl2iA8WJ5qGRnBMwN3HpNfuDANX8n7c9U=";
  };

  cargoRoot = "launcher";
  buildAndTestSubdir = "launcher";

  cargoHash = "sha256-ZfDVuvv/ZJq5Q8C/dw1YOvmdO2Gpv2AQqn0Le6iDaUk=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    systemd
    fontconfig
    freetype
    libGL
    libxcb
    libxkbcommon
    openssl
    vulkan-loader
    wayland
  ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -Dm755 target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/horizon-launcher $out/bin/horizon-launcher

    # Downloaded horizon-client is not wrapped; it inherits this env (libasound, libudev, wgpu/winit).
    wrapProgram $out/bin/horizon-launcher \
      --set-default HORIZON_TELEMETRY_URL off \
      --prefix PATH : ${lib.makeBinPath [ jdk25 ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/horizon-launcher --version
    runHook postInstallCheck
  '';

  passthru.upstreamTag = finalAttrs.src.tag;

  meta = {
    description = "Launcher for Horizon, an unofficial native Minecraft: Java Edition 26.3 client";
    longDescription = ''
      Horizon is Minecraft: Java Edition 26.3 rewritten in Rust. This launcher
      downloads Horizon nightlies, prepares game resources from your own legally
      obtained copy of Minecraft, and starts the client.

      Not an official Minecraft product. Not approved by or associated with
      Mojang or Microsoft. Horizon contains no Minecraft code, assets or data.
    '';
    homepage = "https://playhorizon.dev";
    changelog = "https://github.com/horizon-rust/horizon/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "horizon-launcher";
    platforms = rustc.meta.platforms;
  };
})
