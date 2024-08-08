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
  pname = "neo_f3kdb";
  version = "9";

  src = fetchFromGitHub {
    owner = "HomeOfAviSynthPlusEvolution";
    repo = "neo_f3kdb";
    rev = "refs/tags/r${finalAttrs.version}";
    hash = "sha256-MIvKjsemDeyv9qonuJbns0Dau8BjFQ1REppccs7s9JU=";
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

    install -D -t "$out/lib/vapoursynth" libneo-f3kdb${hostPlatform.extensions.sharedLibrary}

    runHook postInstall
  '';

  meta = {
    description = "Plugin for VapourSynth: neo_f3kdb";
    homepage = "https://github.com/HomeOfAviSynthPlusEvolution/neo_f3kdb";
    license = with lib.licenses; [
      gpl3Plus
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = lib.platforms.x86_64;
  };
})
