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
}:

rustPlatform.buildRustPackage rec {
  pname = "ruffle";
  version = "nightly-2022-12-16";

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = pname;
    rev = version;
    sha256 = "sha256-VOaXn/dJB0AbuZ8owBbUYEPrL/H8DM73MhwhBjxq2Pg=";
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

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dasp-0.11.0" = "sha256-CZNgTLL4IG7EJR2xVp9X9E5yre8foY6VX2hUMRawxiI=";
      "flash-lso-0.5.0" = "sha256-WQ+x0fVIdJPKECc8zA8xITS0vc58e5zxvSHc+UfsO70=";
      "gc-arena-0.2.2" = "sha256-InZH9bzSKa+agqa3T9luWYNhoCwCdpg46mr4D+uWokc=";
      "h263-rs-0.1.0" = "sha256-E1/bWJ/UU3nVz2IKUDaPh3cyoDBbAJ08TnIo/FcABWY=";
      "nellymoser-rs-0.1.2" = "sha256-GykDQc1XwySOqfxW/OcSxkKCFJyVmwSLy/CEBcwcZJs=";
      "nihav_codec_support-0.1.0" = "sha256-rE9AIiQr+PnHC9xfDQULndSfFHSX4sqKkCAQYVNaJcQ=";
      "quick-xml-0.22.0" = "sha256-3rHOChcoBUWaUIJ+ZbJzRAJm2fpV0aa6/76qQB5ICgE=";
    };
  };

  meta = with lib; {
    description = "An Adobe Flash Player emulator written in the Rust programming language.";
    homepage = "https://ruffle.rs/";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ govanify ];
    platforms = platforms.linux;
  };
}
