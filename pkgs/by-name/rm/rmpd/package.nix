{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  aws-lc,
  cacert,
  pipewire,
  sqlite,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rmpd";
  version = "0.19.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "M0Rf30";
    repo = "rmpd";
    tag = finalAttrs.version;
    hash = "sha256-fjOD3W8VSA1smFhMP3iqSsz9+9zthwi/kFeGmyNuBMA=";
  };

  cargoHash = "sha256-kfgkZovTA4DAuVEywMhzhM0ezDz1ZCDVLhbVZfF7j0Y=";

  postPatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    aws-lc
    pipewire
    sqlite
  ];

  env = {
    AWS_LC_SYS_USE_SYSTEM = true;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
  };

  buildFeatures = map (feature: "rmpd/${feature}") [
    "alsa-mixer"
    "coverart"
    "http-api"
    "jellyfin"
    "lastfm"
    "listenbrainz"
    "pipewire"
    "podcast"
    "radio"
    "subsonic"
    "webhook"
  ];

  cargoBuildFlags = [
    "--package"
    "rmpd"
  ];

  nativeCheckInputs = [
    cacert
    writableTmpDirAsHomeHook
  ];

  dontUseCargoParallelTests = true;

  cargoTestFlags = [ "--workspace" ];

  postInstall = ''
    install -Dm644 contrib/systemd/rmpd.{service,socket} -t $out/lib/systemd/user
    substituteInPlace $out/lib/systemd/user/rmpd.service \
      --replace-fail /usr/bin/rmpd $out/bin/rmpd
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Music server speaking the MPD protocol, written in Rust";
    homepage = "https://github.com/M0Rf30/rmpd";
    changelog = "https://github.com/M0Rf30/rmpd/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ savyajha ];
    platforms = lib.platforms.linux;
    mainProgram = "rmpd";
  };
})
