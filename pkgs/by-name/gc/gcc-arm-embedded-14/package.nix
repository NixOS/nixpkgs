{
  lib,
  stdenv,
  fetchurl,
  ncurses6,
  libxcrypt-legacy,
  xz,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "14.3.rel1";

  platform =
    {
      aarch64-darwin = "darwin-arm64";
      aarch64-linux = "aarch64";
      x86_64-linux = "x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/arm-gnu-toolchain-${version}-${platform}-arm-none-eabi.tar.xz";
    # hashes obtained from location ${url}.sha256asc
    sha256 =
      {
        aarch64-darwin = "30f4d08b219190a37cded6aa796f4549504902c53cfc3c7e044a8490b6eba1f7";
        aarch64-linux = "2d465847eb1d05f876270494f51034de9ace9abe87a4222d079f3360240184d3";
        x86_64-linux = "8f6903f8ceb084d9227b9ef991490413014d991874a1e34074443c2a72b14dbd";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

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

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
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
      "aarch64-darwin"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
