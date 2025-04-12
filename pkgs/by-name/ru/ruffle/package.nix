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
  version = "nightly-2024-11-07";
in
rustPlatform.buildRustPackage {
  pname = "ruffle";
  inherit version;

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = "ruffle";
    rev = version;
    hash = "sha256-eufp3myszqguoHGYGqIpv5gMkVx1d4L/GflRgvnxPTQ=";
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

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "flash-lso-0.6.0" = "sha256-dhOAnVfxZw9JaOrY17xAeN7/y/aWZP+KUoDQuCf6D3Q=";
      "h263-rs-0.1.0" = "sha256-dyQHnCe7LwwZYlF57sbRzir9vUavN3K8wLhwPIWlmik=";
      "jpegxr-0.3.1" = "sha256-aV4Qh9ea0CirWU3lScjSKi4mii0cDTnx+miTcqWzxGg=";
      "nellymoser-rs-0.1.2" = "sha256-66yt+CKaw/QFIPeNkZA2mb9ke64rKcAw/6k/pjNYY04=";
      "nihav_codec_support-0.1.0" = "sha256-HAJS4I6yyzQzCf+vmaFp1MWXpcUgFAHPxLhfMVXmN1c=";
    };
  };

  meta = with lib; {
    description = "Adobe Flash Player emulator written in the Rust programming language";
    homepage = "https://ruffle.rs/";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      govanify
      jchw
    ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "ruffle_desktop";
  };
}
