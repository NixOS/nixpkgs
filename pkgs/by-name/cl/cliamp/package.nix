{
  alsa-plugins,
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  makeWrapper,
  alsa-lib,
  libmpg123,
  libogg,
  libvorbis,
  ffmpeg-headless,
  flac,
  pipewire,
  symlinkJoin,
  yt-dlp,
  versionCheckHook,
}:

let
  # The audio backend talks to ALSA, and on PipeWire/PulseAudio systems the
  # host's /etc/alsa/conf.d routes the default device through a plugin named
  # by bare filename ("libasound_module_pcm_pipewire.so"). Nix's libasound only
  # searches its own store path for plugins, so on non-NixOS hosts that lookup
  # fails and cliamp plays into silence. Ship both plugins and point libasound
  # at them.
  alsaPluginDir = symlinkJoin {
    name = "cliamp-alsa-plugins";
    paths = [
      "${alsa-plugins}/lib/alsa-lib"
      "${pipewire}/lib/alsa-lib"
    ];
  };
in

buildGoModule (finalAttrs: {
  pname = "cliamp";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "bjarneo";
    repo = "cliamp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+q3/AfxHtEYH/gzaiimn0gDx98vlytVsJFfYnq04U9Y=";
  };

  vendorHash = "sha256-cythuV9J/Iu+ibRVza8dQ6RHjYKa0hVllc2t6dh3hhs=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libmpg123
    libogg
    libvorbis
    flac
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  # macOS limits Unix socket paths to 104 bytes; use a shorter TMPDIR.
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export TMPDIR="$(mktemp -d /tmp/cliamp-XXXXXX)"
  '';

  postInstall = ''
    wrapProgram "$out/bin/cliamp" \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg-headless
          yt-dlp
        ]
      } \
      ${lib.optionalString stdenv.hostPlatform.isLinux "--set-default ALSA_PLUGIN_DIR ${alsaPluginDir}"}
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 Cliamp.png "$out/share/icons/hicolor/512x512/apps/cliamp.png"
    install -Dm644 cliamp.desktop "$out/share/applications/cliamp.desktop"
  '';

  # this is set due to failure of testset `net/http/httptest` on darwin
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Retro terminal music player inspired by Winamp";
    homepage = "https://github.com/bjarneo/cliamp";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ supermarin ];
    mainProgram = "cliamp";
  };
})
