{
  lib,
  stdenv,
  fetchurl,
  ncurses6,
  libxcrypt-legacy,
  xz,
  zstd,
}:

let
  platform =
    {
      aarch64-darwin = "darwin-arm64";
      aarch64-linux = "aarch64";
      x86_64-linux = "x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gcc-arm-embedded";
  version = "15.3.rel2";

  src = fetchurl {
    url = "https://gitlab.arm.com/api/v4/projects/tooling%2Fgnu-toolchains-for-arm/packages/generic/gnu-toolchain/${finalAttrs.version}/arm-gnu-toolchain-${finalAttrs.version}-${platform}-arm-none-eabi.tar.xz";
    # hashes obtained from location ${url}.sha256asc
    sha256 =
      {
        aarch64-darwin = "b6ccf805aa4fb8c50406256f99cf802385894b86c0cb6c0185dc0e2b5f8288b9";
        aarch64-linux = "9fc9e6baedf2b6779bd39ce4cc458d3529e200bc92bebe28be18f8942a456ad8";
        x86_64-linux = "0662b2f01e0cd8b951fd110911d339c35b05998c68a12b3530bbbb4bf6c7874e";
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

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Pre-built GNU toolchain from ARM Cortex-M & Cortex-R processors";
    homepage = "https://developer.arm.com/open-source/gnu-toolchain/gnu-rm";
    license = with lib.licenses; [
      bsd2
      gpl2
      gpl3
      lgpl21
      lgpl3
      mit
    ];
    maintainers = with lib.maintainers; [
      prusnak
      prtzl
      ryand56
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
