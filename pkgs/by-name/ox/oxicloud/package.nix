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
  version = "0.5.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DioCrafts";
    repo = "OxiCloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+jtFA6SWHcTTEjc+am2oFqJ1cC2bmKb5oppchpAN0SE=";
  };

  cargoHash = "sha256-PxygWzlOhpAKGnP2dT4tDtAJ6AJ2duRcwWZTjHks1lg=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];
  buildInputs = [ openssl ];

  cargoBuildFlags = [ "--bin=oxicloud" ];

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
    homepage = "https://github.com/DioCrafts/OxiCloud";
    changelog = "https://github.com/DioCrafts/OxiCloud/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "oxicloud";
    maintainers = with lib.maintainers; [ flashonfire ];
    platforms = lib.platforms.linux;
  };
})
