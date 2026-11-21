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
  version = "0-unstable-2026-11-18";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "horizon-rust";
    repo = "horizon";
    rev = "1c45cf95d8431a7b49d94df007f7e75a890370c9";
    hash = "sha256-Jfccni40M0bMqOEJh2X4UgYcDeJsSBIDrTFey7cSQew=";
  };

  cargoHash = "sha256-hXShf3bLWAqcUdSDmILbIwpdLWujqurf7Q4zfPQx1Ew=";

  cargoBuildFlags = [
    "--package=horizon-server"
    "--package=horizon-prepare"
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
