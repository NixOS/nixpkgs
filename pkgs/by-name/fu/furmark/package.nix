{
  autoPatchelfHook,
  copyDesktopItems,
  fetchzip,
  lib,
  libGL,
  libGLU,
  libxcrypt-legacy,
  makeDesktopItem,
  makeWrapper,
  stdenv,
  testers,
  vulkan-loader,
}:

let
  description = "OpenGL and Vulkan Benchmark and Stress Test";

  versions = {
    "x86_64-linux" = "2.3.0.0";
    "aarch64-linux" = "2.3.0.0";
    "i686-linux" = "2.0.16";
  };

  sources = {
    "x86_64-linux" = {
      url = "https://gpumagick.com/downloads/files/2024/furmark2/FurMark_${versions.x86_64-linux}_linux64.zip";
      hash = "sha256-9xwnOo8gh6XlX2uTwvEorXsx9FafaeCyCPPPJLJGeuE=";
    };
    "aarch64-linux" = {
      url = "https://gpumagick.com/downloads/files/2024/furmark2/FurMark_${versions.x86_64-linux}_rpi64.zip";
      hash = "sha256-az4prQbg9I+6rt2y1OTy3t21/VHyZS++57r4Ahe3fcQ=";
    };
    "i686-linux" = {
      url = "https://gpumagick.com/downloads/files/2024/furmark2/FurMark_${versions.i686-linux}_linux32.zip";
      hash = "sha256-yXd90FgL3WbTga5x0mXT40BonA2NQtqLzRVzn4s4lLc=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "furmark";
  version =
    versions.${stdenv.hostPlatform.system}
      or (throw "Furmark is not available on ${stdenv.hostPlatform.system}");

  src = fetchzip sources.${stdenv.hostPlatform.system};

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    libGL
    libGLU
  ] ++ lib.optionals stdenv.isAarch64 [ libxcrypt-legacy ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/furmark
    cp -rp * $out/share/furmark

    mkdir -p $out/bin
    for i in $(find $out/share/furmark -maxdepth 1 -type f -executable); do
      ln -s "$i" "$out/bin/$(basename "$i")"
    done

    runHook postInstall
  '';

  appendRunpaths = [ (lib.makeLibraryPath [ vulkan-loader ]) ];

  desktopItems = [
    (makeDesktopItem rec {
      name = "FurMark";
      exec = "FurMark_GUI";
      comment = description;
      desktopName = name;
      genericName = name;
      categories = [
        "System"
        "Monitor"
      ];
    })
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "furmark --version";
    };
  };

  meta = {
    homepage = "https://www.geeks3d.com/furmark/v2/";
    license = lib.licenses.unfree;
    mainProgram = "FurMark_GUI";
    maintainers = with lib.maintainers; [ surfaceflinger ];
    platforms = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    inherit description;
  };
})
