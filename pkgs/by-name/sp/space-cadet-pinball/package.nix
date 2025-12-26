{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  cmake,
  SDL2,
  SDL2_mixer,
  unrar,
}:

let
  assets = fetchzip {
    url = "https://archive.org/download/SpaceCadet_Plus95/Space_Cadet.rar";
    hash = "sha256-fC+zsR8BY6vXpUkVd6i1jF0IZZxVKVvNi6VWCKT+pA4=";
    stripRoot = false;
    nativeBuildInputs = [ unrar ];
  };
  darwinApp = "$out/Applications/SpaceCadetPinball.app/Contents";
  assetsDest =
    if stdenv.hostPlatform.isDarwin then darwinApp + "/Resources" else "$out/share/SpaceCadetPinball";
in
stdenv.mkDerivation rec {
  pname = "SpaceCadetPinball";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "k4zmu2a";
    repo = "SpaceCadetPinball";
    rev = "Release_${version}";
    hash = "sha256-W2P7Txv3RtmKhQ5c0+b4ghf+OMsN+ydUZt+6tB+LClM=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    SDL2
    SDL2_mixer
  ];

  postPatch = ''
    # Change the hardcoded FHS assets path
    substituteInPlace SpaceCadetPinball/pch.h \
      --replace-fail /usr/share ${placeholder "out"}/share
    # Disable building a universal binary on Darwin, otherwise the cc wrapper passing -arch breaks the build
    substituteInPlace CMakeLists.txt \
      --replace-fail "arm64;x86_64" ""
  '';

  # Darwin needs a custom installPhase since it is excluded from the cmake install
  # https://github.com/k4zmu2a/SpaceCadetPinball/blob/0f88e43ba261bc21fa5c3ef9d44969a2a079d0de/CMakeLists.txt#L221
  # This builds a bundle similar to what upstream's build script produces
  # https://github.com/k4zmu2a/SpaceCadetPinball/blob/cb9b7b886244a27773f66b0b19fdc2998392565e/build-mac-app.sh
  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall
    install -D ../bin/SpaceCadetPinball -t ${darwinApp}/MacOS
    install -Dm644 ../Platform/macOS/SpaceCadetPinball.icns -t ${darwinApp}/Resources
    substitute ../Platform/macOS/Info.plist ${darwinApp}/Info.plist \
      --replace-fail CHANGEME_SW_VERSION ${version}
    echo -n "APPL????" > ${darwinApp}/PkgInfo
    runHook postInstall
  '';

  # The game uses SDL_GetBasePath to find the assets directory.
  # On Darwin, this will return Resources/ inside the bundle,
  # on other platforms, the fallback path the game checks is used instead.
  postInstall = ''
    install -Dm644 ${assets}/*.{DAT,DOC,MID,BMP,INF} \
      ${assets}/Sounds/*.WAV -t ${assetsDest}
  '';

  meta = {
    description = "Reverse engineering of 3D Pinball for Windows – Space Cadet, a game bundled with Windows";
    homepage = "https://github.com/k4zmu2a/SpaceCadetPinball";
    # The assets are unfree while the code is labeled as MIT
    license = with lib.licenses; [
      unfree
      mit
    ];
    maintainers = with lib.maintainers; [
      hqurve
      nadiaholmquist
    ];
    platforms = lib.platforms.all;
    mainProgram = "SpaceCadetPinball";
  };
}
