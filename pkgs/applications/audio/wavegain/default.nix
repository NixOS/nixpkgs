{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation {
  pname = "wavegain";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "MestreLion";
    repo = "wavegain";
    rev = "c928eaf97aeec5732625491b64c882e08e314fee";
    sha256 = "0wghqnsbypmr4xcrhb568bfjdnxzzp8qgnws3jslzmzf34dpk5ls";
  };

  patches = [
    # Upstream fix for -fno-common toolchains.
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/MestreLion/wavegain/commit/ee5e0f9a0ce34c0cf2769ea6566685a54b938304.patch";
      sha256 = "11yi0czdn5h5bsqp23cww6yn9lm60cij8i1pzfwcfhgyf6f8ym1n";
    })
  ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    strip -s wavegain
    install -vD wavegain "$out/bin/wavegain"
  '';

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "ReplayGain for wave files";
    homepage = "https://github.com/MestreLion/wavegain";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.robbinch ];
    mainProgram = "wavegain";
  };
}
