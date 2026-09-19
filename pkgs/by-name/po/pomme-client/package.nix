{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  shaderc,
  vulkan-loader,
  vulkan-headers,
  libxkbcommon,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  alsa-lib,
  udev,
  libGL,
  makeWrapper,
}:
rustPlatform.buildRustPackage rec {
  pname = "pomme-client";
  version = "0.1.7+26.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PommeMC";
    repo = "Client";
    rev = "352398a98ca4a2f4f75f8885c10a43999d6e7b86";
    hash = "sha256-g1vVCeggA98VAUAXjupSFirGs6mDPUzbq2tzzXRNzzY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "azalea-auth-0.16.0+mc26.2" = "sha256-onunjouMGQa7CONsJ8wGUGrzo9K37/nMYEBdRKnkNHM=";
    };
  };

  # Nightly-only features required transitively (simdnbt's portable_simd, thiserror's
  # error_generic_member_access probe in azalea-buf); crate-scoped RUSTC_BOOTSTRAP wasn't enough.
  env = {
    RUSTC_BOOTSTRAP = "1";
    SHADERC_LIB_DIR = "${lib.getLib shaderc}/lib";
  };

  buildAndTestSubdir = "pomme-client";

  nativeBuildInputs = [
    pkg-config
    shaderc
    makeWrapper
  ];

  buildInputs = [
    vulkan-loader
    vulkan-headers
    libxkbcommon
    wayland
    libx11
    libxcursor
    libxi
    libxrandr
    alsa-lib
    udev
    libGL
  ];

  postInstall = ''
    wrapProgram $out/bin/pomme-client \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          vulkan-loader
          libxkbcommon
          wayland
          libx11
          libxcursor
          libxi
          libxrandr
          alsa-lib
          udev
          libGL
        ]
      }
  '';

  doCheck = true;

  passthru = {
    inherit cargoLock;
    updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };
  };

  meta = {
    description = "High-performance Minecraft client written in Rust with a Vulkan renderer";
    homepage = "https://github.com/PommeMC/Client";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ DerGrumpf ];
    platforms = lib.platforms.linux;
    mainProgram = "pomme-client";
  };
}
