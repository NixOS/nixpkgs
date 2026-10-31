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
  version = "0.2.28";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "horizon-rust";
    repo = "horizon";
    tag = "launcher@${finalAttrs.version}";
    hash = "sha256-7+Mdwsn3vX7Tnzq9eczV4n+K05z8TBsue6kOr8faaSk=";
  };

  cargoRoot = "launcher";
  buildAndTestSubdir = "launcher";

  cargoHash = "sha256-PNl2JQNEgi9F+//Qzqdzakh1WNd4ByUF+wg3W/t0kZk=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
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

    wrapProgram $out/bin/horizon-launcher \
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
