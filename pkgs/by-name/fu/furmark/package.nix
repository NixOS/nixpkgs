{ autoPatchelfHook
, copyDesktopItems
, fetchzip
, lib
, libGL
, libGLU
, makeDesktopItem
, makeWrapper
, stdenv
, vulkan-loader
}:

let
  description = "OpenGL and Vulkan Benchmark and Stress Test";
  versions = {
    "x86_64-linux" = "2.1.0.2";
    "i686-linux" = "2.0.16";
  };

  sources = {
    "x86_64-linux" = {
      url = "https://gpumagick.com/downloads/files/2024/furmark2/FurMark_${versions.x86_64-linux}_linux64.zip";
      hash = "sha256-CTWW40p2MZt2nUP/LocbqeaF0k+R94lFBd+zpcLCSSU=";
    };
    "i686-linux" = {
      url = "https://gpumagick.com/downloads/files/2024/furmark2/FurMark_${versions.i686-linux}_linux32.zip";
      hash = "sha256-yXd90FgL3WbTga5x0mXT40BonA2NQtqLzRVzn4s4lLc=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "furmark";
  version = versions.${stdenv.system};

  src = fetchzip (sources.${stdenv.system});

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    libGL
    libGLU
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/furmark
    cp -rp * $out/share/furmark

    runHook postInstall
  '';

  postFixup = ''
    for i in $(find $out/share/furmark -maxdepth 1 -type f -executable); do
      makeWrapper "$i" "$out/bin/$(basename "$i")" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
    done
  '';

  desktopItems = [
    (makeDesktopItem rec {
      name = "FurMark";
      exec = "FurMark_GUI";
      comment = description;
      desktopName = name;
      genericName = name;
      categories = [ "System" "Monitor" ];
    })
  ];

  meta = with lib; {
    homepage = "https://www.geeks3d.com/furmark/v2/";
    license = licenses.unfree;
    mainProgram = "FurMark_GUI";
    maintainers = with maintainers; [ surfaceflinger ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    inherit description;
  };
})
