{
  lib,
  stdenv,
  fetchFromGitHub,
  hostPlatform,
  cmake,
  pkg-config,
  vapoursynth,
  tbb,
  zimg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neo_dfttest";
  version = "8";

  src = fetchFromGitHub {
    owner = "HomeOfAviSynthPlusEvolution";
    repo = "neo_dfttest";
    rev = "refs/tags/r${finalAttrs.version}";
    hash = "sha256-qlgg57Ysr/iwZz6RjJcLEYN/eRaG/LB3dIExY9FyXls=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    tbb
    zimg
  ];

  cmakeFlags = [ (lib.cmakeFeature "VERSION" "r${finalAttrs.version}") ];

  postPatch = ''
    sed -E -i '/^find_package\(Git /,+2d' CMakeLists.txt
    rm -rf include/vapoursynth
  '';

  installPhase = ''
    runHook preInstall

    install -D -t "$out/lib/vapoursynth" libneo-dfttest${hostPlatform.extensions.sharedLibrary}

    runHook postInstall
  '';

  meta = {
    description = "Plugin for VapourSynth: neo_dfttest";
    homepage = "https://github.com/HomeOfAviSynthPlusEvolution/neo_dfttest";
    license = with lib.licenses; [
      gpl3Plus
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = lib.platforms.x86_64;
  };
})
