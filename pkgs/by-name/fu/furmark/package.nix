{
  autoPatchelfHook,
  copyDesktopItems,
  fetchurl,
  fetchzip,
  lib,
  libGL,
  libGLU,
  libxcrypt-legacy,
  makeDesktopItem,
  makeWrapper,
  p7zip,
  stdenv,
  testers,
  vulkan-loader,
}:

let
  description = "OpenGL and Vulkan Benchmark and Stress Test";

  versions = {
    "x86_64-linux" = "2.10.2";
    "aarch64-linux" = "2.10.1";
    "i686-linux" = "2.0.16";
  };

  sources = {
    "x86_64-linux" = {
      url = "https://gpumagick.com/downloads/files/2025/fm2/2_10_dbc69dd0a08da5ff09169a4fc759ddaa/FurMark_${versions.x86_64-linux}_linux64.7z";
      hash = "sha256-s9AEj9r7kBhPGPU365HgxS9tEyrm7UjLtoxD21pCrts=";
    };
    "aarch64-linux" = {
      url = "https://gpumagick.com/downloads/files/2025/fm2/2_10_dbc69dd0a08da5ff09169a4fc759ddaa/FurMark_${versions.aarch64-linux}_arm64.7z";
      hash = "sha256-XQuK6UgZOjwqpENkHVYsoiG9zyZAbNjR+65hj9dvAY8=";
    };
    "i686-linux" = {
      url = "https://gpumagick.com/downloads/files/2024/furmark2/FurMark_${versions.i686-linux}_linux32.zip";
      hash = "sha256-yXd90FgL3WbTga5x0mXT40BonA2NQtqLzRVzn4s4lLc=";
    };
  };

  is7z =
    (stdenv.hostPlatform.system == "x86_64-linux") || (stdenv.hostPlatform.system == "aarch64-linux");

  linkLogs =
    (stdenv.hostPlatform.system == "x86_64-linux") || (stdenv.hostPlatform.system == "aarch64-linux");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "furmark";
  version =
    versions.${stdenv.hostPlatform.system}
      or (throw "Furmark is not available on ${stdenv.hostPlatform.system}");

  src = fetchurl sources.${stdenv.hostPlatform.system};

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    p7zip
  ];

  buildInputs = [
    libGL
    libGLU
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [ libxcrypt-legacy ];

  unpackPhase = ''
    runHook preUnpack
    7z x $src
  ''
  + lib.optionalString is7z ''
    mv FurMark_linux64/* .
    rmdir FurMark_linux64
  ''
  + ''
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/furmark
    cp -rp * $out/share/furmark
  ''
  + lib.optionalString linkLogs ''
    ln -sf /tmp/furmark-geexlab.log $out/share/furmark/_geexlab_log.txt
    ln -sf /tmp/furmark-furmark.log $out/share/furmark/_furmark_log.txt
  ''
  + ''
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
      icon = fetchurl {
        url = "https://www.geeks3d.com/furmark/i/20240220-furmark-logo-02.png";
        hash = "sha256-EqhWQgTEmF/2AcqDxgGtr2m5SMYup28hPEhI6ssFw7g=";
      };
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
    maintainers = with lib.maintainers; [
      surfaceflinger
      w1lldu
    ];
    platforms = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    inherit description;
  };
})
