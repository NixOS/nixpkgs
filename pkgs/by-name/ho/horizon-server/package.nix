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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "horizon-server";
  version = "0-unstable-2026-11-02";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "horizon-rust";
    repo = "horizon";
    rev = "b2258cbf68346a146b125f6a45d479e9e9584b4c";
    hash = "sha256-EILkMLy99s7w1vnJERW9HwxSKKaAKbJPXmMkwiaj9M8=";
  };

  cargoHash = "sha256-i3aryNUgV+ZFG9sr4X8LvaqDuqgGHaYLv8CpiLngfic=";

  cargoBuildFlags = [
    "--package=horizon-server"
    "--package=horizon-prepare"
    "--package=horizon-client"
  ];

  # horizon-engine is horizon-client without audio/controllers (docs/server.md).
  buildNoDefaultFeatures = true;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
  ];

  # Parity harnesses need a prepared vanilla tree; not available in the Nix sandbox.
  doCheck = false;

  installPhase = ''
    runHook preInstall

    cargoOut="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"

    mkdir -p $out/lib/horizon-server $out/bin
    install -Dm755 $cargoOut/horizon-client $out/lib/horizon-server/horizon-engine
    install -Dm755 $cargoOut/horizon-server $out/lib/horizon-server/horizon-server
    install -Dm755 $cargoOut/horizon-prepare $out/lib/horizon-server/horizon-prepare
    install -Dm644 research-lock.json $out/lib/horizon-server/
    cp -r mods $out/lib/horizon-server/

    for prog in horizon-server horizon-prepare; do
      makeWrapper $out/lib/horizon-server/$prog $out/bin/$prog \
        --prefix PATH : ${lib.makeBinPath [ jdk25 ]}
    done

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/horizon-server --version
    $out/bin/horizon-prepare --version
    runHook postInstallCheck
  '';

  passthru.upstreamTag = "nightly";

  meta = {
    description = "Dedicated server for Horizon, an unofficial native Minecraft: Java Edition 26.3 implementation";
    longDescription = ''
      Hosts a Minecraft Java Edition 26.3 compatible server using Horizon's
      native engine. Game files must be prepared from your own legally obtained
      copy of Minecraft with horizon-prepare before the server can run.

      Not an official Minecraft product. Not approved by or associated with
      Mojang or Microsoft. Horizon contains no Minecraft code, assets or data.
    '';
    homepage = "https://playhorizon.dev";
    changelog = "https://github.com/horizon-rust/horizon/releases/tag/${finalAttrs.passthru.upstreamTag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "horizon-server";
    platforms = rustc.meta.platforms;
  };
})
