{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,
  cairo,
  curl,
  expat,
  fontconfig,
  freetype,
  glib,
  harfbuzz,
  libice,
  libsm,
  libx11,
  libxext,
  libxcb,
  libxcb-cursor,
  libxcb-keysyms,
  libxcb-util,
  libxkbcommon,
  openssl,
  pango,
  zstd,
}:
stdenv.mkDerivation {
  pname = "serum2";
  version = "2.1.5-beta-2026-10-31";

  strictDeps = true;
  __structuredAttrs = true;

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://www.dropbox.com/scl/fi/j0dxx8enype4d91e3r1k3/Serum2_Linux_Beta_26-10-31_bbcd310_x86_64.tar.xz?rlkey=fmyye6omla9k1b7p7y011bi3q&st=4ipk0uif&dl=1";
        hash = "sha256-VcbDiry+r6oxjVB09tkXBlvXD0vySc1w469zIlDFgno=";
      };
      aarch64-linux = fetchurl {
        url = "https://www.dropbox.com/scl/fi/0bcsve2nucaa1c1hs3us1/Serum2_Linux_Beta_aarch64_26-08-13_3d11ff7.tar.gz?rlkey=zjlxnxvgfbh6g841xlexz9js8&st=4pphshxv&dl=1";
        hash = "sha256-a/RJ09OyRtYMOGqPUEO1vnpJ/2XdePwsxkocV3FVe0g=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    cairo
    curl
    expat
    fontconfig
    freetype
    glib
    harfbuzz
    libice
    libsm
    libx11
    libxext
    libxcb
    libxcb-cursor
    libxcb-keysyms
    libxcb-util
    libxkbcommon
    openssl
    pango
    stdenv.cc.cc.lib
    zstd
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/vst3"
    cp -r . "$out/lib/vst3/Serum2.vst3"

    runHook postInstall
  '';

  meta = {
    description = "Xfer Records Serum 2 wavetable synthesizer";
    homepage = "https://xferrecords.com/products/serum";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ _9prestidigitator ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
