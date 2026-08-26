{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  jre_minimal,
  pkg-config,
  autoPatchelfHook,
  alsa-lib,
  dbus,
  fontconfig,
  wayland,
  libxcursor,
  libxrandr,
  libxi,
  libx11,
  libxcb,
  vulkan-loader,
  udev,
  libxkbcommon,
  openh264,
  openssl,
  writeShellApplication,
  curl,
  jq,
  nix-update,
  withX11 ? true,
  withRuffleTools ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ruffle";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = "ruffle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/x9blMac62JqA5eWUBqye3g2PWVWYJlOaPysXNSahgA=";
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

  cargoHash = "sha256-DSSKisWHbI0Cwiuqyg6EzvHIXB6fdV17nhXDQnqQIdM=";
  cargoBuildFlags = lib.optional withRuffleTools "--workspace";

  env =
    let
      commitDate = "2026-07-19";
    in
    {
      VERGEN_IDEMPOTENT = "1";
      VERGEN_GIT_SHA = "v${finalAttrs.version}";
      VERGEN_GIT_COMMIT_DATE = commitDate;
      VERGEN_GIT_COMMIT_TIMESTAMP = "${commitDate}T00:00:00Z";
    };

  nativeBuildInputs = [
    jre_minimal
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs = [
    fontconfig
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    udev
    openssl
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux (
    [
      wayland
      libxkbcommon
      vulkan-loader
      openh264
      (lib.getLib dbus)
    ]
    ++ lib.optionals withX11 [
      libxcursor
      libxrandr
      libxi
      libx11
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
          curl https://api.github.com/repos/ruffle-rs/ruffle/releases/latest | \
          jq -r ".tag_name" \
        )"
        exec nix-update --version "''${version#v}" ruffle
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
    changelog = "https://github.com/ruffle-rs/ruffle/releases/tag/v${finalAttrs.version}";
    maintainers = [
      lib.maintainers.jchw
    ];
    mainProgram = "ruffle";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
