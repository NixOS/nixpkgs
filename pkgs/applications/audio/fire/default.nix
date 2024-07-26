{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, catch2
, libX11
, libXrandr
, libXinerama
, libXext
, libXcursor
, freetype
, alsa-lib
, Accelerate
, Cocoa
, WebKit
, CoreServices
, DiscRecording
, CoreAudioKit
, MetalKit
, simd
}:

let
  # FetchContent replacement, check CMakeLists.txt for requested versions (Nixpkgs' Catch2 works)
  readerwriterqueue = fetchFromGitHub {
    owner = "cameron314";
    repo = "readerwriterqueue";
    rev = "v1.0.6";
    sha256 = "sha256-g7NX7Ucl5GWw3u6TiUOITjhv7492ByTzACtWR0Ph2Jc=";
  };
in
stdenv.mkDerivation rec {
  pname = "fire";
  version = "1.0.0.3";

  src = fetchFromGitHub {
    owner = "jerryuhoo";
    repo = "Fire";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-X3pzTrNd0G6BouCDkr3dukQTFDzZ7qblIYxFQActKGE=";
  };

  patches = [
    ./0001-Remove-FetchContent-usage.patch
  ];

  postPatch = ''
    # 1. Remove hardcoded LTO flags: needs extra setup on Linux,
    #    possibly broken on Darwin
    #    https://github.com/NixOS/nixpkgs/issues/19098
    # 2. Disable automatic copying of built plugins during buildPhase, it defaults
    #    into user home and we want to have building & installing separated.
    sed -i \
      -e '/juce::juce_recommended_lto_flags/d' \
      -e 's/COPY_PLUGIN_AFTER_BUILD TRUE/COPY_PLUGIN_AFTER_BUILD FALSE/g' \
      CMakeLists.txt
  '';

  preConfigure = ''
    ln -s ${readerwriterqueue} readerwriterqueue
    ln -s ${catch2.src} Catch2
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libX11
    libXrandr
    libXinerama
    libXext
    libXcursor
    freetype
    alsa-lib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Accelerate
    Cocoa
    WebKit
    CoreServices
    DiscRecording
    CoreAudioKit
    MetalKit
    simd
  ];

  installPhase = let
    vst3Dir = "${placeholder "out"}/${if stdenv.hostPlatform.isDarwin then "Library/Audio/Plug-Ins/VST3" else "lib/vst3"}";
    auDir = "${placeholder "out"}/Library/Audio/Plug-Ins/Components";
  in ''
    runHook preInstall

    mkdir -p ${vst3Dir}
    # Exact path of the build artefact depends on used CMAKE_BUILD_TYPE
    cp -R Fire_artefacts/*/VST3/* ${vst3Dir}/
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p ${auDir}
    cp -R Fire_artefacts/*/AU/* ${auDir}/
  '' + ''

    runHook postInstall
  '';

  # Fails to find fp.h on its own
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-isystem ${CoreServices}/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/CarbonCore.framework/Versions/Current/Headers/";

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = with lib; {
    description = "Multi-band distortion plugin by Wings";
    homepage = "https://github.com/jerryuhoo/Fire";
    license = licenses.agpl3Only; # Not clarified if Only or Plus
    platforms = platforms.unix;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
