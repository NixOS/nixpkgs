{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  just,
  pkg-config,
  makeBinaryWrapper,
  libcosmicAppHook,

  libxkbcommon,
  openssl,
  wayland,

  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "quick-webapps";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "web-apps";
    tag = finalAttrs.version;
    hash = "sha256-yd4lALm7eG4NxrvaduZC1SZEE83j/nRsG2ufrfUMJJM=";
  };

  cargoHash = "sha256-gg8WCzKbpFT8SRzMxC7ezvv+uN9IpIbGy/yytFC9uaM=";

  nativeBuildInputs = [
    just
    pkg-config
    libcosmicAppHook
  ];

  buildInputs = [
    libxkbcommon
    openssl
  ];

  env.VERGEN_GIT_SHA = finalAttrs.src.tag;

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/quick-webapps"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web App Manager for the COSMIC desktop";
    homepage = "https://github.com/cosmic-utils/web-apps";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "quick-webapps";
  };
})
