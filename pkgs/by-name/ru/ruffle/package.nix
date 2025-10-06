{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  jre_minimal,
  pkg-config,
  autoPatchelfHook,
  alsa-lib,
  wayland,
  libXcursor,
  libXrandr,
  libXi,
  libX11,
  libxcb,
  vulkan-loader,
  udev,
  libxkbcommon,
  openh264,
  writeShellApplication,
  curl,
  jq,
  nix-update,
  withX11 ? true,
  withRuffleTools ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ruffle";
  version = "0.2.0-nightly-2025-10-05";

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = "ruffle";
    tag = lib.strings.removePrefix "0.2.0-" finalAttrs.version;
    hash = "sha256-u12Qfc0fmcs7TU35/gqfRxjSpw9SDbc4+ebR7lGpvJI=";
  };

  postPatch =
    let
      versionList = lib.versions.splitVersion openh264.version;
      major = lib.elemAt versionList 0;
      minor = lib.elemAt versionList 1;
      patch = lib.elemAt versionList 2;
    in
    ''
      substituteInPlace video/external/src/decoder/openh264.rs \
        --replace-fail "OpenH264Version(2, 4, 1)" \
                       "OpenH264Version(${major}, ${minor}, ${patch})"
    '';

  cargoHash = "sha256-v/3vf7YYJiz+PMBsznvOJsNLtv6bEQ9pffAI33rLVuw=";
  cargoBuildFlags = lib.optional withRuffleTools "--workspace";

  env =
    let
      tag = lib.strings.removePrefix "0.2.0-" finalAttrs.version;
      versionDate = lib.strings.removePrefix "0.2.0-nightly-" finalAttrs.version;
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

  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux (
    [
      wayland
      libxkbcommon
      vulkan-loader
      openh264
    ]
    ++ lib.optionals withX11 [
      libXcursor
      libXrandr
      libXi
      libX11
      libxcb
    ]
  );

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
        exec nix-update --version "0.2.0-$version" ruffle
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
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    changelog = "https://github.com/ruffle-rs/ruffle/releases/tag/${lib.strings.removePrefix "0.2.0-" finalAttrs.version}";
    maintainers = [
      lib.maintainers.jchw
      lib.maintainers.normalcea
    ];
    mainProgram = "ruffle";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
