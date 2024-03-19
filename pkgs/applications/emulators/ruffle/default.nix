{ alsa-lib
, fetchFromGitHub
, makeWrapper
, openssl
, pkg-config
, python3
, rustPlatform
, lib
, wayland
, xorg
, vulkan-loader
, jre_minimal
, cairo
, gtk3
, wrapGAppsHook
, gsettings-desktop-schemas
, glib
, libxkbcommon
}:

rustPlatform.buildRustPackage rec {
  pname = "ruffle";
  version = "nightly-2024-02-09";

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = pname;
    rev = version;
    hash = "sha256-C4wfR5io0FBFmNfYHlE/v81jQAb0SEoaCzI6tenRYGg=";
  };

  nativeBuildInputs = [
    glib
    gsettings-desktop-schemas
    jre_minimal
    makeWrapper
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
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
  ];

  dontWrapGApps = true;

  preFixup = ''
    patchelf $out/bin/ruffle_desktop \
      --add-needed libxkbcommon-x11.so \
      --add-rpath ${libxkbcommon}/lib
  '';

  postFixup = ''
    # This name is too generic
    mv $out/bin/exporter $out/bin/ruffle_exporter

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
      "flash-lso-0.6.0" = "sha256-SHWIOVp3MGIATKDKAGNWG3B3jX3a0jDE2c8bt7NptrE=";
      "h263-rs-0.1.0" = "sha256-Akf1SBjo8qikhiHI8NPvO3vJvVfm0dQBf2X9V7OdgQc=";
      "jpegxr-0.3.0" = "sha256-jirUbse2MiUDCmwBO7ykWNKHgDgL/6ZM5o2HeDUhm0c=";
      "nellymoser-rs-0.1.2" = "sha256-GykDQc1XwySOqfxW/OcSxkKCFJyVmwSLy/CEBcwcZJs=";
      "nihav_codec_support-0.1.0" = "sha256-HAJS4I6yyzQzCf+vmaFp1MWXpcUgFAHPxLhfMVXmN1c=";
    };
  };

  meta = with lib; {
    description = "An Adobe Flash Player emulator written in the Rust programming language";
    homepage = "https://ruffle.rs/";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ govanify jchw ];
    platforms = platforms.linux;
    mainProgram = "ruffle_desktop";
  };
}
