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
  version = "nightly-2024-09-12";
in
rustPlatform.buildRustPackage {
  pname = "ruffle";
  inherit version;

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = "ruffle";
    rev = version;
    hash = "sha256-wvgx6581vvUPb9evvJl328oTP/F8+LhpeHX3vCsHXCc=";
  };

  nativeBuildInputs =
    [ jre_minimal ]
    ++ lib.optionals stdenv.isLinux [
      glib
      gsettings-desktop-schemas
      makeWrapper
      pkg-config
      python3
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs =
    lib.optionals stdenv.isLinux [
      alsa-lib
      cairo
      gtk3
      openssl
      wayland
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXi
      xorg.libxcb
      xorg.libXrender
      vulkan-loader
      udev
    ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  dontWrapGApps = true;

  preFixup = lib.optionalString stdenv.isLinux ''
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
    + lib.optionalString stdenv.isLinux ''
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
      "ecolor-0.28.1" = "sha256-X1prQIc3jzmWyEmpfQMgowW2qM1r+2T12Nd7HCsPtpc=";
      "flash-lso-0.6.0" = "sha256-X9XYj88GmkPRy+RxvGM6vFdBxif2XYesKtqwwW2DTw4=";
      "h263-rs-0.1.0" = "sha256-dyQHnCe7LwwZYlF57sbRzir9vUavN3K8wLhwPIWlmik=";
      "jpegxr-0.3.1" = "sha256-03gbXA5T02ofgfRaanaixqfrFpxw/UOOftgKZ7hPHY4=";
      "nellymoser-rs-0.1.2" = "sha256-66yt+CKaw/QFIPeNkZA2mb9ke64rKcAw/6k/pjNYY04=";
      "nihav_codec_support-0.1.0" = "sha256-HAJS4I6yyzQzCf+vmaFp1MWXpcUgFAHPxLhfMVXmN1c=";
      "rfd-0.14.1" = "sha256-eq4OONgYrtWCogIpjws/1uRxmv3oyIdrimDVaLJ9IMo=";
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
