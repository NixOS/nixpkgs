{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  freetype,
  ftgl,
  libjack2,
  libX11,
  lv2,
  libGLU,
  libGL,
  pkg-config,
  ttf_bitstream_vera,
  nix-update-script,
}:
let
  version = "0.8.13";
in
stdenv.mkDerivation {
  pname = "setbfree";
  inherit version;

  src = fetchFromGitHub {
    owner = "pantherb";
    repo = "setBfree";
    rev = "v${version}";
    hash = "sha256-jtiyJntaFnAVeC1Rvkzi3wNodyJpEQKgnOAP7++36wo=";
  };

  postPatch = ''
    substituteInPlace common.mak \
      --replace /usr/local "$out" \
      --replace /usr/share/fonts/truetype/ttf-bitstream-vera "${ttf_bitstream_vera}/share/fonts/truetype"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    alsa-lib
    freetype
    ftgl
    libjack2
    libX11
    lv2
    libGLU
    libGL
    ttf_bitstream_vera
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    (
      set -x;
      test -e $out/bin/setBfreeUI
    )
  '';

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "DSP tonewheel organ emulator";
    homepage = "https://setbfree.org";
    license = lib.licenses.gpl2;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ]; # fails on ARM and Darwin
    broken = stdenv.hostPlatform.isAarch64;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
}
