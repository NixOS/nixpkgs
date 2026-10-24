{
  libglvnd,
  libxkbcommon,
  vulkan-loader,
  vulkan-headers,
  wayland,
  wayland-protocols,
  rustPlatform,
  fetchFromGitHub,
  lib,
  python3,
  bash,
  pkg-config,
  cmake,
  git,
  alsa-lib,
  ffmpeg_9,
  dav1d,
  libyuv,
  shaderc,
  zlib,
  libdrm,
  libva-minimal,
  libpulseaudio,
  stdenv,
  nix-update-script,
}:
let
  graphicsRuntime = [
    libglvnd
    libxkbcommon
    vulkan-loader
    wayland
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "skwd-paper-v2";
  version = "1.0.0-beta.26";

  src = fetchFromGitHub {
    owner = "liixini";
    repo = "skwd-paper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hFNHfsfEREBD2dDTfdnADY93Q0u2DEDoOBtgAz5Ur5o=";
  };
  cargoHash = "sha256-pLEYnduGL553nEm1AUOlpqqr2GcwIGOb4ZBCYcON7hg=";
  env.VULKAN_INCLUDE_DIR = "${vulkan-headers}/include";

  postPatch = ''
    substituteInPlace crates/paper-cli/src/server_tests.rs \
      --replace-fail '#!/usr/bin/python3' '#!${python3}/bin/python3'
    while IFS= read -r -d ""; do
      substituteInPlace "$REPLY" --replace-quiet '#!/bin/sh' '#!${bash}/bin/sh'
    done < <(find . -name '*.rs' -print0)
  '';

  nativeBuildInputs = [
    pkg-config
    wayland
    wayland-protocols
    cmake
    rustPlatform.bindgenHook
    git
    python3
    shaderc
    zlib
  ];

  buildInputs = [
    alsa-lib
    ffmpeg_9
    dav1d
    libyuv
    libdrm
    libpulseaudio
    libva-minimal
    shaderc
    stdenv.cc.cc.lib
    zlib
    vulkan-headers
  ]
  ++ graphicsRuntime;

  preCheck = ''
    export LD_LIBRARY_PATH="${lib.makeLibraryPath graphicsRuntime}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  '';

  postFixup = ''
    for bin in "$out"/bin/skwd-wall-vk "$out"/bin/skwd-paper-v2; do
      patchelf --add-rpath "${
        lib.makeLibraryPath (
          [
            alsa-lib
          ]
          ++ graphicsRuntime
        )
      }" $bin
    done
  '';

  cargoBuildFlags = [
    "--manifest-path"
    "Cargo.toml"
    "--package"
    "skwd-paper"
    "--package"
    "paper-tinier"
    "--package"
    "skwd-wall-vk"
    "--package"
    "skwd-wall-still"
  ];

  cargoTestFlags = [
    "--manifest-path"
    "Cargo.toml"
    "--package"
    "skwd-paper"
    "--package"
    "paper-tinier"
    "--package"
    "skwd-wall-vk"
    "--package"
    "skwd-wall-still"
  ];

  postInstall = ''
    mv $out/bin/skwd-paper $out/bin/skwd-paper-v2
    mkdir -p $out/share/licenses/skwd-paper-v2/third-party
    cp -r $src/LICENSE $out/share/licenses/skwd-paper-v2/
    cp -r $src/LICENSES/{OpenH264-BSD-2-Clause.txt,dav1d-BSD-2-Clause.txt,libyuv-BSD-3-Clause.txt} $out/share/licenses/skwd-paper-v2/third-party
  '';

  meta = {
    description = "Still, video, and Wallpaper Engine renderers for Skwd";
    homepage = "https://github.com/liixini/skwd-wall";
    license = with lib.licenses; [
      mit
      bsd2
      bsd3
    ];
    maintainers = with lib.maintainers; [
      futurekismo
      HomieDerPrakti
    ];
    mainProgram = "skwd-paper-v2";
    platforms = [ "x86_64-linux" ];
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=unstable" ];
  };
})
