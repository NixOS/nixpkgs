{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gfortran,
  libzip,
  lhapdf,
  patchelf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sherpa";
  version = "3.0.3";

  src = fetchFromGitLab {
    owner = "sherpa-team";
    repo = "sherpa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bh5C0BYbuAkbPrp27P0oD0yoxd53ViRtmpUKfN7kZ90=";
  };

  postPatch = lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
    sed -i -e '/sys\/sysctl.h/d' ATOOLS/Org/Run_Parameter.C
  '';

  nativeBuildInputs = [
    cmake
    gfortran
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ patchelf ];

  buildInputs = [
    libzip
    lhapdf
  ];

  cmakeFlags = [
    # Needed to initialize a valid SHERPA_LIBRARY_PATH
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  preFixup =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -add_rpath "$out"/lib/SHERPA-MC "$out"/bin/Sherpa
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --add-rpath "$out"/lib/SHERPA-MC "$out"/bin/Sherpa
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
})
