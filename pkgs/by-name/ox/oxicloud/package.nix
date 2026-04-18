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
  version = "0.5.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DioCrafts";
    repo = "OxiCloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nn8qgLdiw7w4PZIMCiI+UHZGNW64fjWZ5mErTJifRZU=";
  };

  cargoHash = "sha256-4KfrKL2AKkTt3cOXdl9Xr2qed+qy8WSWuqYfN8WJ0bQ=";

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
