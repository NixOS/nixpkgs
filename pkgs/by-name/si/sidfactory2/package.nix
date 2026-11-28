{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  libjack2,
  rtmidi,
  gnused,
  libicns,
  librsvg,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  version = "20260308";
in
stdenv.mkDerivation {
  pname = "sidfactory2";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Chordian";
    repo = "sidfactory2";
    rev = "d89ae8eb1707b75341c38d61b6e14f7720774785";
    hash = "sha256-WI34c54gjEhzkt8AjtXjiWJKgiVlIbm/D8UCJY+YuTI=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    SDL2
    libjack2
    rtmidi
  ];

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      SDL2
      copyDesktopItems
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      gnused
      libicns
      librsvg
    ];

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "sidfactory2";
      exec = "sidfactory2";
      icon = "sidfactory2";
      desktopName = "SID Factory II";
      categories = [
        "AudioVideo"
        "Audio"
      ];
    })
  ];

  postPatch = ''
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      # iconutil is part of Xcode and unavailable in the Nix build environment.
      substituteInPlace macos/Makefile \
        --replace-fail 'iconutil -c icns -o $@ $(ICONSET)' 'png2icns $@ $(ICONSET)/icon_16x16.png $(ICONSET)/icon_32x32.png $(ICONSET)/icon_128x128.png $(ICONSET)/icon_256x256.png $(ICONSET)/icon_512x512.png $(ICONSET)/icon_512x512@2x.png'
      substituteInPlace macos/Makefile \
        --replace-fail 'gsed -i' 'sed -i'
      substituteInPlace macos/Makefile \
        --replace-fail 'cp -r App/' 'cp -R App/Contents'
    ''}

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      # RtMidi checks for __UNIX_JACK__ to enable its JACK backend.
      substituteInPlace Makefile \
        --replace-fail '-DUNIX_JACK' '-D__UNIX_JACK__'
    ''}

    # asid.cpp uses uint64_t without including its defining header.
    sed -i '/^#include <array>$/a #include <cstdint>' \
      SIDFactoryII/source/runtime/emulation/asid/asid.cpp
  '';

  buildPhase = ''
    runHook preBuild
    ${
      if stdenv.hostPlatform.isDarwin then
        "make -C macos app BUILD_NR=${version}"
      else
        "make dist BUILD_NR=${version}"
    }
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          install -d $out/Applications $out/bin
          cp -R macos/artifacts/SIDFactoryII.app $out/Applications/
          ln -s $out/Applications/SIDFactoryII.app/Contents/MacOS/SIDFactoryII $out/bin/sidfactory2
        ''
      else
        ''
          ARTIFACT_DIR=$(find artifacts -type d -name "SIDFactoryII_*" | head -n 1)
          install -Dm444 macos/icon.svg $out/share/icons/hicolor/scalable/apps/sidfactory2.svg

          cd "$ARTIFACT_DIR" || {
            echo "Error: Could not find build artifacts directory 'SIDFactoryII_*' inside 'artifacts/'"
            exit 1
          }

          install -D -m 555 SIDFactoryII $out/bin/sidfactory2
          install -d $out/bin/overlay
          find drivers -type f -exec install -m 444 -D {} $out/bin/{} \;
        ''
    }

    runHook postInstall
  '';

  meta = with lib; {
    description = "SID Factory II - A cross-platform tracker for Commodore 64 music";
    homepage = "https://blog.chordian.net/sf2/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ kmogged ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "sidfactory2";
  };
}
