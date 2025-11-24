{
  lib,
  stdenv,
  fetchFromGitLab,
  autoconf,
  gfortran,
  cmake,
  libzip,
  pkg-config,
  lhapdf,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  pname = "sherpa";
  version = "3.0.2";

  src = fetchFromGitLab {
    owner = "sherpa-team";
    repo = "sherpa";
    tag = "v${version}";
    hash = "sha256-VlC5MnbrXp2fdO2EtBjtw45Gx6PhF/hcLy0ajlKp10E=";
  };

  postPatch = lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
    sed -i -e '/sys\/sysctl.h/d' ATOOLS/Org/Run_Parameter.C
  '';

  nativeBuildInputs = [
    autoconf
    gfortran
    cmake
    pkg-config
    autoPatchelfHook
  ];

  buildInputs = [
    libzip
    lhapdf
  ];

  enableParallelBuilding = true;

  preFixup = ''
    patchelf --add-rpath $out/lib/SHERPA-MC $out/bin/Sherpa
  '';

  meta = {
    description = "Monte Carlo event generator for the Simulation of High-Energy Reactions of PArticles";
    license = lib.licenses.gpl3Plus;
    homepage = "https://gitlab.com/sherpa-team/sherpa";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  };
}
