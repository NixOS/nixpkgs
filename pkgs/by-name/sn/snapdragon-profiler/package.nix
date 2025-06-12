{
  lib,
  stdenv,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  icoutils,
  mono,
  jre,
  androidenv,
  gtk-sharp-2_0,
  gtk2,
  libcxx,
  coreutils,
  requireFile,
  archive ? requireFile {
    name = "snapdragonprofiler_external_linux.tar.gz";
    message = ''
      This nix expression requires that "snapdragonprofiler_external_linux.tar.gz" is
      already part of the store. To get this archive, you need to download it from:
        https://developer.qualcomm.com/software/snapdragon-profiler
      and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
    '';
    sha256 = "c6731c417ca39fa9b0f190bd80c99b1603cf97d23becab9e47db6beafd6206b7";
  },
}:

stdenv.mkDerivation rec {
  pname = "snapdragon-profiler";
  version = "2021.2";

  src = archive;

  nativeBuildInputs = [
    makeWrapper
    icoutils
    copyDesktopItems
  ];

  buildInputs = [
    mono
    gtk-sharp-2_0
    gtk2
    libcxx
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/snapdragon-profiler}
    mkdir -p $out/share/icons/hicolor/{16x16,32x32,48x48}/apps

    mv *.so $out/lib
    cp -r * $out/lib/snapdragon-profiler
    makeWrapper "${mono}/bin/mono" $out/bin/snapdragon-profiler \
      --add-flags "$out/lib/snapdragon-profiler/SnapdragonProfiler.exe" \
      --suffix PATH : ${
        lib.makeBinPath [
          jre
          androidenv.androidPkgs.platform-tools
          coreutils
        ]
      } \
      --prefix MONO_GAC_PREFIX : ${gtk-sharp-2_0} \
      --suffix LD_LIBRARY_PATH : $(echo $NIX_LDFLAGS | sed 's/ -L/:/g;s/ -rpath /:/g;s/-rpath //') \
      --chdir "$out/lib/snapdragon-profiler" # Fixes themes not loading correctly

    wrestool -x -t 14 SnapdragonProfiler.exe > snapdragon-profiler.ico
    icotool -x -i 1 -o $out/share/icons/hicolor/16x16/apps/snapdragon-profiler.png snapdragon-profiler.ico
    icotool -x -i 2 -o $out/share/icons/hicolor/32x32/apps/snapdragon-profiler.png snapdragon-profiler.ico
    icotool -x -i 3 -o $out/share/icons/hicolor/48x48/apps/snapdragon-profiler.png snapdragon-profiler.ico

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Snapdragon Profiler";
      exec = "snapdragon-profiler";
      icon = "snapdragon-profiler";
      comment = meta.description;
      categories = [
        "Development"
        "Debugger"
        "Graphics"
        "3DGraphics"
      ];
    })
  ];

  dontStrip = true; # Always needed on Mono
  dontPatchELF = true; # Certain libraries are to be deployed to the remote device, they should not be patched

  meta = with lib; {
    homepage = "https://developer.qualcomm.com/software/snapdragon-profiler";
    description = "Profiler for Android devices running Snapdragon chips";
    license = licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
