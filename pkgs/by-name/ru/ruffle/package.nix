{
  alsa-lib,
  fetchFromGitHub,
  makeWrapper,
  openssl,
  pkg-config,
  python3,
  rustPlatform,
  stdenvNoCC,
  lib,
  wayland,
  xorg,
  vulkan-loader,
  udev,
  jre_minimal,
  cairo,
  gtk3,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
  glib,
  libxkbcommon,
  openh264,
  darwin,
  versionCheckHook,
  nix-update-script,
}:
let
  pname = "ruffle";
  version = "nightly-2025-03-10";
  versionDate = lib.removePrefix "nightly-" version;
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
in
rustPlatform.buildRustPackage (finalAttrs: {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = "ruffle";
    tag = "${finalAttrs.version}";
    hash = "sha256-VwDnl2KNFt5Dq7/CxF0APtc8LqF91JTttXH5gpQDHxU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ccAp8BIZ9Xax6jNTr3SZVh4U9ZMyQds6iDL5XRcJsVU=";

  env.VERGEN_IDEMPOTENT = "1";
  env.VERGEN_GIT_SHA = version;
  env.VERGEN_GIT_COMMIT_DATE = versionDate;
  env.VERGEN_GIT_COMMIT_TIMESTAMP = "${versionDate}T00:00:00Z";

  nativeBuildInputs =
    [ jre_minimal ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
      glib
      gsettings-desktop-schemas
      makeWrapper
      pkg-config
      python3
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs =
    lib.optionals stdenvNoCC.hostPlatform.isLinux [
      alsa-lib
      cairo
      gtk3
      openssl
      wayland
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libxcb
      xorg.libXrender
      vulkan-loader
      udev
    ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  postInstall =
    ''
      # This name is too specific
      mv $out/bin/ruffle_desktop $out/bin/ruffle
    ''
    + lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      install -Dm644 desktop/packages/linux/rs.ruffle.Ruffle.desktop \
                     -t $out/share/applications/

      install -Dm644 desktop/packages/linux/rs.ruffle.Ruffle.svg \
                     -t $out/share/icons/hicolor/scalable/apps/

      install -Dm644 desktop/packages/linux/rs.ruffle.Ruffle.metainfo.xml \
                     -t $out/share/metainfo/
    '';

  preFixup = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        libxkbcommon
        openh264-241
        vulkan-loader
        wayland
      ]
    })
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cross platform Adobe Flash Player emulator";
    longDescription = ''
      Ruffle is a cross platform emulator for running and preserving
      Adobe Flash content. It is capable of running ActionScript 1, 2
      and 3 programs with machine-native performance thanks to being
      written in the Rust programming language.
    '';
    homepage = "https://ruffle.rs/";
    downloadPage = "https://ruffle.rs/downloads";
    changelog = "https://github.com/ruffle-rs/ruffle/releases/tag/${finalAttrs.version}";
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
