{
  lib,
  stdenv,
  fetchFromGitHub,
  ensureNewerSourcesForZipFilesHook,
  makeDesktopItem,
  imagemagick,
  cmake,
  pkg-config,
  alsa-lib,
  freetype,
  webkitgtk_4_0,
  zenity,
  curl,
  xorg,
  python3,
  makeWrapper,
}:

let
  # data copied from build system: https://build.opensuse.org/package/view_file/home:plugdata/plugdata/PlugData.desktop
  desktopItem = makeDesktopItem {
    name = "PlugData";
    desktopName = "PlugData";
    exec = "plugdata";
    icon = "plugdata_logo.png";
    comment = "Pure Data as a plugin, with a new GUI";
    type = "Application";
    categories = [
      "AudioVideo"
      "Music"
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "plugdata";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "plugdata-team";
    repo = "plugdata";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qG9fH5C42jiHj03p/KM28jmDIkJkrQMe7fxg92Lg7B4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ensureNewerSourcesForZipFilesHook
    imagemagick
    python3
    makeWrapper
  ];
  buildInputs = [
    alsa-lib
    curl
    freetype
    webkitgtk_4_0
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXinerama
    xorg.libXrender
    xorg.libXrandr
  ];
  # Standard fix for JUCE programs: https://github.com/NixOS/nixpkgs/blob/5014727e62ae7b22fb1afc61d789ca6ad9170435/pkgs/applications/audio/bespokesynth/default.nix#L137
  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux "-rpath ${
    lib.makeLibraryPath ([
      xorg.libX11
      xorg.libXrandr
      xorg.libXinerama
      xorg.libXext
      xorg.libXcursor
      xorg.libXrender
    ])
  }";
  dontPatchELF = true; # needed or nix will try to optimize the binary by removing "useless" rpath

  postPatch = ''
    # Don't build LV2 plugin (it hangs), and don't automatically install
    sed -i 's/ LV2 / /g' CMakeLists.txt
  '';

  installPhase = ''
    runHook preInstall

    cd .. # build artifacts are placed inside the source directory for some reason
    mkdir -p $out/{bin,lib/{clap,vst3}}
    cp    Plugins/Standalone/plugdata      $out/bin
    cp -r Plugins/CLAP/plugdata{,-fx}.clap $out/lib/clap
    cp -r Plugins/VST3/plugdata{,-fx}.vst3 $out/lib/vst3

    icon_name="plugdata_logo.png"
    icon_path="Resources/Icons/$icon_name"

    install -m644 -D "${desktopItem}"/share/applications/* -t $out/share/applications
    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize "$size"x"$size" "$icon_path" $out/share/icons/hicolor/"$size"x"$size"/apps/"$icon_name"
    done

    runHook postInstall
  '';

  postInstall = ''
    # Ensure zenity is available, or it won't be able to open new files.
    # These X11 libs get dlopen'd, they cause visual bugs when unavailable.
    wrapProgram $out/bin/plugdata \
      --prefix PATH : '${
        lib.makeBinPath [
          zenity
        ]
      }' \
      --prefix LD_LIBRARY_PATH : '${
        lib.makeLibraryPath [
          xorg.libXrandr
          xorg.libXinerama
          xorg.libXcursor
          xorg.libXrender
        ]
      }'
  '';

  meta = with lib; {
    description = "Plugin wrapper around Pure Data to allow patching in a wide selection of DAWs";
    mainProgram = "plugdata";
    homepage = "https://plugdata.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ PowerUser64 ];
  };
})
