{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  openssl,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxicloud";
  version = "0.6.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AtalayaLabs";
    repo = "OxiCloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7alpcK0KYg+ZusK2K7FPdQMLdPrawvL5wsfB6NpSXQw=";
  };

  cargoHash = "sha256-4gxpTCsS1W2CmRzdnRcsuRe+kr+TgG4hjkzdgihop5I=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];
  buildInputs = [ openssl ];

  cargoBuildFlags = [ "--bin=oxicloud" ];

  postPatch = ''
    # Upstream pins `target-cpu=native`, making the binary non-portable
    # (breaks the binary cache). Build for the generic baseline instead.
    rm -f .cargo/config.toml
  '';

  postInstall = ''
    mkdir -p $out/share/oxicloud
    cp -r static-dist $out/share/oxicloud/static
  '';

  postFixup = ''
    wrapProgram $out/bin/oxicloud \
      --set-default OXICLOUD_STATIC_PATH $out/share/oxicloud/static
  '';

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
