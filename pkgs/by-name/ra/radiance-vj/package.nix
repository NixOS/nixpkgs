{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  mpv-unwrapped,
  vulkan-loader,
  stdenv,
  alsa-lib,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  libxinerama,
  libxpresent,
  libxfixes,
  libxext,
  libxcb,
  yt-dlp,
}:

rustPlatform.buildRustPackage rec {
  pname = "radiance";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "zbanks";
    repo = "radiance";
    rev = version;
    hash = "sha256-RWPcbUg7/gggPuUZLyMJ/m2S5GGfrdE6SWyXERIXsdk=";
  };

  cargoHash = "sha256-ESEFpGxqfDPOY1vrQk0IeOZiP8c5RNwPeKF3vRZRW0Q=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    mpv-unwrapped
    vulkan-loader
    libxkbcommon
    alsa-lib
    wayland
    libx11
    libxcursor
    libxi
    libxrandr
    libxinerama
    libxpresent
    libxfixes
    libxext
    libxcb
  ];

  propagatedUserEnvPkgs = [
    yt-dlp
  ];

  preFixup = ''
    patchelf \
      --add-rpath "${
        lib.makeLibraryPath [
          libxkbcommon
          libx11
          libxcursor
          libxi
          libxrandr
          libxinerama
          libxpresent
          libxfixes
          libxext
        ]
      }:$out/lib" \
      $out/bin/radiance \
      --add-needed libxkbcommon-x11.so
  '';

  # Floating-point exact-equality bugs upstream
  doCheck = false;

  meta = {
    description = "Video art software for VJs";
    homepage = "https://github.com/zbanks/radiance";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ magnetophon ];
    mainProgram = "radiance";
    platforms = lib.platforms.linux;
  };
}
