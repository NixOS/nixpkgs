{
  lib,
  stdenv,
  fetchurl,
  ncurses6,
  libxcrypt-legacy,
  xz,
  zstd,
  makeBinaryWrapper,
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "14.2.rel1";

  platform =
    {
      aarch64-darwin = "darwin-arm64";
      aarch64-linux = "aarch64";
      x86_64-darwin = "darwin-x86_64";
      x86_64-linux = "x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/arm-gnu-toolchain-${version}-${platform}-arm-none-eabi.tar.xz";
    # hashes obtained from location ${url}.sha256asc
    sha256 =
      {
        aarch64-darwin = "c7c78ffab9bebfce91d99d3c24da6bf4b81c01e16cf551eb2ff9f25b9e0a3818";
        aarch64-linux = "87330bab085dd8749d4ed0ad633674b9dc48b237b61069e3b481abd364d0a684";
        x86_64-darwin = "2d9e717dd4f7751d18936ae1365d25916534105ebcb7583039eff1092b824505";
        x86_64-linux = "62a63b981fe391a9cbad7ef51b17e49aeaa3e7b0d029b36ca1e9c3b2a9b78823";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    makeBinaryWrapper
    darwin.sigtool
  ];

  patches = [
    # fix double entry in share/info/porting.info
    # https://github.com/NixOS/nixpkgs/issues/363902
    ./info-fix.patch
  ];

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    cp -r * $out
    # these binaries require ancient Python 3.8 not available in Nixpkgs
    rm $out/bin/{arm-none-eabi-gdb-py,arm-none-eabi-gdb-add-index-py} || :
  '';

  preFixup =
    lib.optionalString stdenv.isLinux ''
      find $out -type f | while read f; do
        patchelf "$f" > /dev/null 2>&1 || continue
        patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
        patchelf --set-rpath ${
          lib.makeLibraryPath [
            "$out"
            stdenv.cc.cc
            ncurses6
            libxcrypt-legacy
            xz
            zstd
          ]
        } "$f" || true
      done
    ''
    + lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
      find "$out" -executable -type f | while read executable; do
        ( \
          install_name_tool \
            -change "/usr/local/opt/zstd/lib/libzstd.1.dylib" "${lib.getLib zstd}/lib/libzstd.1.dylib" \
            -change "/usr/local/opt/xz/lib/liblzma.5.dylib" "${lib.getLib xz}/lib/liblzma.5.dylib" \
            "$executable" \
          && codesign -f -s - "$executable" \
        ) || true
      done
    '';

  meta = with lib; {
    description = "Pre-built GNU toolchain from ARM Cortex-M & Cortex-R processors";
    homepage = "https://developer.arm.com/open-source/gnu-toolchain/gnu-rm";
    license = with licenses; [
      bsd2
      gpl2
      gpl3
      lgpl21
      lgpl3
      mit
    ];
    maintainers = with maintainers; [
      prusnak
      prtzl
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
