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
  version = "15.2.rel1";

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
        aarch64-darwin = "1938a84b7105c192e3fb4fa5e893ba25f425f7ddab40515ae608cd40f68669a8";
        aarch64-linux = "d061559d814b205ed30c5b7c577c03317ec447ca51cd5a159d26b12a5bbeb20c";
        x86_64-linux = "597893282ac8c6ab1a4073977f2362990184599643b4c5ee34870a8215783a16";
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
}
