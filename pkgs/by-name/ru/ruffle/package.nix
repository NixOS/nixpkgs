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
}:
let
  pname = "ruffle";
  version = "nightly-2025-01-25";
  # TODO: Remove overridden derivation once ruffle accepts upstream openh264-2.5.0
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
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = pname;
    tag = version;
    hash = "sha256-JLh0tatP70rYo2QXLKu6M9jJ1gFpY76sYaUJqW9U4E0=";
  };

  patches = [ ./remove-deterministic-feature.patch ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-PbNp/V+xmU6Lo24a6pd9XoT/LQmINztjOHKoikG9N4Y=";

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

  cargoBuildFlags = [ "--workspace" ];

  postInstall =
    ''
      # Namespace binaries with "ruffle_"
      mv $out/bin/exporter $out/bin/ruffle_exporter
      mv $out/bin/mocket $out/bin/ruffle_mocket
      mv $out/bin/stub-report $out/bin/ruffle_stub-report
      mv $out/bin/build_playerglobal $out/bin/ruffle_build_playerglobal

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

      rm $out/bin/ruffle_web_safari
    '';

  preFixup = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    patchelf $out/bin/ruffle \
      --add-needed libxkbcommon-x11.so \
      --add-needed libwayland-client.so \
      --add-needed libopenh264.so \
      --add-rpath ${libxkbcommon}/lib:${wayland}/lib:${openh264-241}/lib
  '';

  dontWrapGApps = true;

  postFixup = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    vulkanWrapperArgs+=(
      --prefix LD_LIBRARY_PATH ':' ${vulkan-loader}/lib
    )

    wrapProgram $out/bin/ruffle_exporter \
      "''${vulkanWrapperArgs[@]}"

    wrapProgram $out/bin/ruffle \
      "''${vulkanWrapperArgs[@]}" \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "Cross platform Adobe Flash Player emulator";
    longDescription = ''
      Ruffle is a cross platform emulator for running and preserving
      Adobe Flash content. It is capable of running ActionScript 1, 2
      and 3 programs with machine-native performance thanks to being
      written in the Rust programming language.

      This package for ruffle also includes the `exporter` and
      `scanner` utilities which allow for generating screenshots as
      PNGs and parsing `.swf` files in bulk respectively.
    '';
    homepage = "https://ruffle.rs/";
    downloadPage = "https://ruffle.rs/downloads";
    changelog = "https://github.com/ruffle-rs/ruffle/releases/tag/${version}";
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
}
