{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "govee2mqtt";
  version = "2025.11.25-60a39bcc";

  src = fetchFromGitHub {
    owner = "wez";
    repo = "govee2mqtt";
    tag = finalAttrs.version;
    hash = "sha256-8N/qQHJvVKWdlPQDbLskGw9le0L7yzTwxwz1w4cFu5g=";
  };

  cargoPatches = [
    ./dont-vendor-openssl.diff
  ];

  postPatch = ''
    substituteInPlace src/service/http.rs \
      --replace '"assets"' '"${placeholder "out"}/share/govee2mqtt/assets"'
  '';

  cargoHash = "sha256-rs3wfvotR2p7jC6dn+JkTLJxVBtQR/IWgM9KmoYSelA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  postInstall = ''
    mkdir -p $out/share/govee2mqtt/
    cp -r assets $out/share/govee2mqtt/
  '';

  meta = {
    description = "Connect Govee lights and devices to Home Assistant";
    homepage = "https://github.com/wez/govee2mqtt";
    changelog = "https://github.com/wez/govee2mqtt/blob/${finalAttrs.version}/addon/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "govee";
  };
})
