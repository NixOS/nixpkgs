{
  lib,
  stdenv,
  rustPlatform,
  withRuffleTools ? false,
  fetchFromGitHub,
  jre_minimal,
  pkg-config,
  autoPatchelfHook,
  alsa-lib,
  wayland,
  xorg,
  vulkan-loader,
  udev,
  libxkbcommon,
  openh264,
  writeShellApplication,
  curl,
  jq,
  nix-update,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ruffle";
  version = "0.2-nightly-2025-10-05";

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = "ruffle";
    tag = lib.strings.removePrefix "0.2-" finalAttrs.version;
    hash = "sha256-u12Qfc0fmcs7TU35/gqfRxjSpw9SDbc4+ebR7lGpvJI=";
  };

  cargoHash = "sha256-v/3vf7YYJiz+PMBsznvOJsNLtv6bEQ9pffAI33rLVuw=";
  cargoBuildFlags = lib.optional withRuffleTools "--workspace";

  env =
    let
      tag = lib.strings.removePrefix "0.2-" finalAttrs.version;
      versionDate = lib.strings.removePrefix "0.2-nightly-" finalAttrs.version;
    in
    {
      VERGEN_IDEMPOTENT = "1";
      VERGEN_GIT_SHA = tag;
      VERGEN_GIT_COMMIT_DATE = versionDate;
      VERGEN_GIT_COMMIT_TIMESTAMP = "${versionDate}T00:00:00Z";
    };

  nativeBuildInputs = [
    jre_minimal
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    autoPatchelfHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    udev
    (lib.getLib stdenv.cc.cc)
  ];

  # Prevents ruffle from downloading openh264 at runtime for Linux
  openh264-241 =
    if stdenv.hostPlatform.isLinux then
      openh264.overrideAttrs (_: rec {
        version = "2.4.1";
        src = fetchFromGitHub {
          owner = "cisco";
          repo = "openh264";
          tag = "v${version}";
          hash = "sha256-ai7lcGcQQqpsLGSwHkSs7YAoEfGCIbxdClO6JpGA+MI=";
        };
      })
    else
      null;

  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libX11
    xorg.libxcb
    libxkbcommon
    vulkan-loader
    finalAttrs.openh264-241
  ];

  postInstall = ''
    mv $out/bin/ruffle_desktop $out/bin/ruffle
    install -Dm644 LICENSE.md -t $out/share/doc/ruffle
    install -Dm644 README.md -t $out/share/doc/ruffle
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 desktop/packages/linux/rs.ruffle.Ruffle.desktop \
                   -t $out/share/applications/

    install -Dm644 desktop/packages/linux/rs.ruffle.Ruffle.svg \
                   -t $out/share/icons/hicolor/scalable/apps/

    install -Dm644 desktop/packages/linux/rs.ruffle.Ruffle.metainfo.xml \
                   -t $out/share/metainfo/
  '';

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "ruffle-update";
      runtimeInputs = [
        curl
        jq
        nix-update
      ];
      text = ''
        version="$( \
          curl https://api.github.com/repos/ruffle-rs/ruffle/releases?per_page=1 | \
          jq -r ".[0].tag_name" \
        )"
        exec nix-update --version "0.2-$version" ruffle
      '';
    });
  };

  meta = {
    description = "Cross platform Adobe Flash Player emulator";
    longDescription = ''
      Ruffle is a cross platform emulator for running and preserving
      Adobe Flash content. It is capable of running ActionScript 1, 2
      and 3 programs with machine-native performance thanks to being
      written in the Rust programming language.

      Additionally, overriding the `withRuffleTools` input to
      `true` will build all the available packages in the ruffle
      project, including the `exporter` and `scanner` utilities.
    '';
    homepage = "https://ruffle.rs/";
    downloadPage = "https://ruffle.rs/downloads";
    changelog = "https://github.com/ruffle-rs/ruffle/releases/tag/${lib.strings.removePrefix "0.2" finalAttrs.version}";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = [
      lib.maintainers.jchw
      lib.maintainers.normalcea
    ];
    mainProgram = "ruffle";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
