{
  lib,
  stdenvNoCC,
  fetchurl,
  callPackage,
  makeBinaryWrapper,
  autoPatchelfHook,
  gcc,
  libgcc,
  icu,
  libx11,
  libxcursor,
  libxinerama,
  libxi,
  libxrandr,
  libGL,
  libglvnd,
  libxkbcommon,
  wayland,
  alsa-lib,
  vulkan-loader,
  vulkan-validation-layers,
  libpulseaudio,
  dotnet-runtime_10,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  version = "2026.5.5.4304"; # Bump to update
  pname = "ksa";
  src = fetchurl {
    url = "https://ksa-linux.ahwoo.com/download?file=setup_ksa_v${finalAttrs.version}.tar.gz";
    sha256 = "sha256-2vWAZHH3FF5ce7vkzHmVBEXcr/ae7HnXeEFfKYG6GO4=";
  };

  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
  ];

  buildInputs = [
    libgcc
    icu
    wayland
    libx11
    libxcursor
    libxinerama
    libxi
    libxrandr
    libGL
    libglvnd
    libxkbcommon
    alsa-lib
    vulkan-loader
    vulkan-validation-layers
    libpulseaudio
    dotnet-runtime_10
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/ksa
    cp -a * $out/share/ksa
    chmod +x $out/share/ksa/KSA
    chmod +x $out/share/ksa/Brutal.Monitor.Subprocess

    makeBinaryWrapper "$out/share/ksa/KSA" "$out/bin/KSA" \
      --unset WAYLAND_DISPLAY \
      --unset WAYLAND_SOCKET \
      --set XDG_SESSION_TYPE "x11" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --prefix VK_LAYER_PATH : "${vulkan-validation-layers}/share/vulkan/explicit_layer.d" \
      --prefix PATH : "${dotnet-runtime_10}" \
      --set DOTNET_ROOT "${dotnet-runtime_10}/share/dotnet" \
      --set DOTNET_ROOT_X64 "${dotnet-runtime_10}/share/dotnet" \
      --chdir $out/share/ksa

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://ksa.ahwoo.com";
    description = "Mission to create the spaceflight game that inspires the next generation of space explorers";
    #changelog = ""; # Space intentionally left blank, at the moment of writing, changelogs are only published in the game's discord
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "KSA";
    maintainers = with lib.maintainers; [
      leha44581
      maevii
    ];
  };
})
