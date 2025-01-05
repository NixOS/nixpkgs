{
  alsa-lib,
  fetchFromGitHub,
  makeWrapper,
  openssl,
  pkg-config,
  python3,
  rustPlatform,
  stdenv,
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
  darwin,
}:
let
  version = "nightly-2025-01-04";
in
rustPlatform.buildRustPackage {
  pname = "ruffle";
  inherit version;

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = "ruffle";
    rev = version;
    hash = "sha256-MxYl5fTTNerCwG3w34cltb6aasP6TvGRkvwf77lKIgs=";
  };

  nativeBuildInputs =
    [ jre_minimal ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib
      gsettings-desktop-schemas
      makeWrapper
      pkg-config
      python3
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  dontWrapGApps = true;

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 -t $out/share/icons/hicolor/scalable/apps/ desktop/packages/linux/rs.ruffle.Ruffle.svg

    install -Dm644 -t $out/share/applications/ desktop/packages/linux/rs.ruffle.Ruffle.desktop
    substituteInPlace $out/share/applications/rs.ruffle.Ruffle.desktop \
    --replace-fail "Exec=ruffle %u" "Exec=ruffle_desktop %u"

    install -Dm644 -t $out/share/metainfo/ desktop/packages/linux/rs.ruffle.Ruffle.metainfo.xml
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/ruffle_desktop \
      --add-needed libxkbcommon-x11.so \
      --add-needed libwayland-client.so \
      --add-rpath ${libxkbcommon}/lib:${wayland}/lib
  '';

  postFixup =
    ''
      # This name is too generic
      mv $out/bin/exporter $out/bin/ruffle_exporter
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      vulkanWrapperArgs+=(
        --prefix LD_LIBRARY_PATH ':' ${vulkan-loader}/lib
      )

      wrapProgram $out/bin/ruffle_exporter \
        "''${vulkanWrapperArgs[@]}"

      wrapProgram $out/bin/ruffle_desktop \
        "''${vulkanWrapperArgs[@]}" \
        "''${gappsWrapperArgs[@]}"
    '';

  cargoBuildFlags = [ "--workspace" ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-q+9yhUjYolPlBt6W1xJPoyE7DgqDffEhkQqJmSX4y3Y=";

  meta = {
    description = "Cross platform Adobe Flash Player emulator";
    homepage = "https://ruffle.rs/";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = [
      lib.maintainers.govanify
      lib.maintainers.jchw
      lib.maintainers.normalcea
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "ruffle_desktop";
  };
}
