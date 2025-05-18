{
  lib,
  stdenvNoCC,
  rustPlatform,
  withRuffleTools ? false,
  fetchFromGitHub,
  jre_minimal,
  pkg-config,
  wrapGAppsHook3,
  alsa-lib,
  gtk3,
  openssl,
  wayland,
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
  version = "0-nightly-2025-05-11";

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = "ruffle";
    tag = lib.strings.removePrefix "0-" finalAttrs.version;
    hash = "sha256-m/4e15znssmDASvuLu7BpkhKLZmw7TZ2nXB0bAPrN+4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JtapILlrDbTFBa763h04lMMP2xQxW0vOpAfyIlHPjeI=";
  cargoBuildFlags = lib.optional withRuffleTools "--workspace";

  env =
    let
      tag = lib.strings.removePrefix "0-" finalAttrs.version;
      versionDate = lib.strings.removePrefix "0-nightly-" finalAttrs.version;
    in
    {
      VERGEN_IDEMPOTENT = "1";
      VERGEN_GIT_SHA = tag;
      VERGEN_GIT_COMMIT_DATE = versionDate;
      VERGEN_GIT_COMMIT_TIMESTAMP = "${versionDate}T00:00:00Z";
    };

  nativeBuildInputs =
    [ jre_minimal ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
      pkg-config
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    alsa-lib
    gtk3
    openssl
    wayland
    vulkan-loader
    udev
  ];

  postInstall =
    ''
      mv $out/bin/ruffle_desktop $out/bin/ruffle
      install -Dm644 LICENSE.md -t $out/share/doc/ruffle
      install -Dm644 README.md -t $out/share/doc/ruffle
    ''
    + lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      install -Dm644 desktop/packages/linux/rs.ruffle.Ruffle.desktop \
                     -t $out/share/applications/

      install -Dm644 desktop/packages/linux/rs.ruffle.Ruffle.svg \
                     -t $out/share/icons/hicolor/scalable/apps/

      install -Dm644 desktop/packages/linux/rs.ruffle.Ruffle.metainfo.xml \
                     -t $out/share/metainfo/
    '';

  # Prevents ruffle from downloading openh264 at runtime for Linux
  openh264-241 =
    if stdenvNoCC.hostPlatform.isLinux then
      openh264.overrideAttrs (_: rec {
        version = "2.4.1";
        src = fetchFromGitHub {
          owner = "cisco";
          repo = "openh264";
          tag = "v${version}";
          hash = "sha256-ai7lcGcQQqpsLGSwHkSs7YAoEfGCIbxdClO6JpGA+MI=";
        };
        postPatch = null;
      })
    else
      null;

  preFixup = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        libxkbcommon
        finalAttrs.openh264-241
        vulkan-loader
        wayland
      ]
    })
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
        exec nix-update --version "0-$version" ruffle
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
    changelog = "https://github.com/ruffle-rs/ruffle/releases/tag/${lib.strings.removePrefix "0-" finalAttrs.version}";
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
