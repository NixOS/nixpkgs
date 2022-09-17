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
, Cocoa
, WebKit
, CoreServices
, DiscRecording
, CoreAudioKit
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
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "jerryuhoo";
    repo = "Fire";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-HOXkoX5CjWFdWGP8ngzPgAJ3KKSZ10aKF3CIh4rGRpw=";
  };

  patches = [
    ./0001-Remove-FetchContent-usage.patch
  ];

  postPatch = let
    vst3Dir = "${placeholder "out"}/${if stdenv.hostPlatform.isDarwin then "Library/Audio/Plug-Ins/VST3" else "lib/vst3"}";
    auDir = "${placeholder "out"}/Library/Audio/Plug-Ins/Components";
  in ''
    # 1. Remove hardcoded LTO flags: needs extra setup on Linux,
    #    possibly broken on Darwin
    #    https://github.com/NixOS/nixpkgs/issues/19098
    # 2. Set copy locations for built plugins, defaults are into user home.
    #    Setting this stuff here is easier than disabling & manually moving
    #    stuff around in the proper install phase.
    sed -i \
      -e '/juce::juce_recommended_lto_flags/d' \
      -e '/COPY_PLUGIN_AFTER_BUILD/a VST3_COPY_DIR "${vst3Dir}"\nAU_COPY_DIR "${auDir}"' \
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
    Cocoa
    WebKit
    CoreServices
    DiscRecording
    CoreAudioKit
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin (toString [
    # Fails to find fp.h on its own
    "-isystem ${CoreServices}/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/CarbonCore.framework/Versions/Current/Headers/"
  ]);

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # JUCE handles installation during buildPhase
  dontInstall = true;

  meta = with lib; {
    description = "Multi-band distortion plugin by Wings";
    homepage = "https://github.com/jerryuhoo/Fire";
    license = licenses.agpl3Only; # Not clarified if Only or Plus
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
