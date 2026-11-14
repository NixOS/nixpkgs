{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  cairo,
  libGL,
  lv2,
  libjack2,
  libgbm,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stone-phaser";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "stone-phaser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jbk6ZMPH7y3l9fKLUp+1VU3m+m8hl4LBRfEniL4YC6A=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    cairo
    libGL
    lv2
    libjack2
    libgbm
  ];

  postPatch = ''
    patch -d dpf -p 1 -i "$src/resources/patch/DPF-bypass.patch"
    patchShebangs ./dpf/utils/generate-ttl.sh

    # Fix gcc-13 build failure due to missing includes
    sed -e '1i #include <cstdint>' -i plugins/stone-phaser/ui/Color.h
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    homepage = "https://github.com/jpcima/stone-phaser";
    description = "Classic analog phaser effect, made with DPF and Faust";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.boost;
  };
})
