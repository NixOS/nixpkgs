{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  pipewire,
  wayland,
  fontconfig,
  freetype,
  libglvnd,
  libxkbcommon,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
  vulkan-loader,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openmeters";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "httpsworldview";
    repo = "openmeters";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gtrX9MPZFUy+cMk4MPTNL2+QmORZ9rJ9WEivALgiy5M=";
  };

  cargoHash = "sha256-LNELcHA45EEtdwW9iMQqtD0aVA/8Q69xdo+GXklTkQc=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    pipewire
    libxkbcommon
  ];

  postFixup = ''
    patchelf --add-rpath '${
      lib.makeLibraryPath [
        fontconfig
        freetype
        libglvnd
        libxkbcommon
        wayland
        libx11
        libxcursor
        libxi
        libxrandr
        vulkan-loader
      ]
    }' $out/bin/openmeters
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast and professional audio metering/visualization for Linux";
    longDescription = ''
      OpenMeters is a fast audio metering application for Linux built with
      Rust and PipeWire. It provides LUFS/RMS/true-peak loudness meters
      (ITU-R BS.1770-5), a spectrogram with spectral reassignment, a
      spectrum analyser, an oscilloscope with stable-trigger mode, a
      stereometer (X/Y vector scope, M/S goniometer) and a waveform view,
      with per-application and per-device capture.
    '';

    homepage = "https://github.com/httpsworldview/openmeters";
    changelog = "https://github.com/httpsworldview/openmeters/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      bitbloxhub
      magnetophon
    ];
    platforms = lib.platforms.linux;
    mainProgram = "openmeters";
  };
})
