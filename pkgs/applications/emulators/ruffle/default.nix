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
, udev
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
  version = "nightly-2024-03-25";

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = pname;
    rev = version;
    hash = "sha256-3G5xSGdMl4ISQmb2BVGdKz1cXU5Mnl+VkVYpJ6P12og=";
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
    udev
  ];

  dontWrapGApps = true;

  preFixup = ''
    patchelf $out/bin/ruffle_desktop \
      --add-needed libxkbcommon-x11.so \
      --add-needed libwayland-client.so \
      --add-rpath ${libxkbcommon}/lib:${wayland}/lib
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
      "flash-lso-0.6.0" = "sha256-sVe53VRtBEEI6eERWRv6aG6BBT31sSLvJ6CSCcif2Lo=";
      "h263-rs-0.1.0" = "sha256-EBYZ00axaILGc2CtJoPQpewlf6+jlmml+cXZFyoxhHQ=";
      "jpegxr-0.3.1" = "sha256-YbQMi86DXqdi7o0s5ajAv7/vFaxNpShz19cNa9MpOsA=";
      "nellymoser-rs-0.1.2" = "sha256-66yt+CKaw/QFIPeNkZA2mb9ke64rKcAw/6k/pjNYY04=";
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
