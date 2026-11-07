{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  openssl,
  pkg-config,
  rustPlatform,
  buildNpmPackage,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxicloud";
  version = "0.8.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AtalayaLabs";
    repo = "OxiCloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9bUfHSBXEEwU35J7zXdpS7zPKOFyCerQq5WQ6rO5tag=";
  };

  cargoHash = "sha256-M3gl00jSvykx6+ewbvgEZiNL9bDDjfnq089nYXiwEiQ=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [ openssl ];

  cargoBuildFlags = [ "--bin=oxicloud" ];

  postPatch = ''
    # Upstream pins `target-cpu=native`, making the binary non-portable
    # (breaks the binary cache). Build for the generic baseline instead.
    rm -f .cargo/config.toml
  '';

  oxicloud-front = buildNpmPackage (frontFinalAttrs: {
    pname = "oxicloud-front";
    inherit (finalAttrs) version src;
    sourceRoot = "${frontFinalAttrs.src.name}/frontend";

    npmDepsHash = "sha256-dn9vEk84AYaqfhBhf2obsfQBYUPkE5qyjXalFNNziXw=";

    postPatch = ''
      substituteInPlace svelte.config.js \
        --replace "'../static-dist'" "'static-dist'"
    '';

    installPhase = ''
      runHook preInstall
      cp -r static-dist $out
      runHook postInstall
    '';
  });

  postInstall = ''
    mkdir -p $out/share/oxicloud
  '';

  postFixup = ''
    wrapProgram $out/bin/oxicloud \
      --set-default OXICLOUD_STATIC_PATH ${finalAttrs.oxicloud-front}
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
