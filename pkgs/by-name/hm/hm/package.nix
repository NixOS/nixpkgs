{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  cmake,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hm";
  version = "18.0";

  src = fetchFromGitLab {
    domain = "vcgit.hhi.fraunhofer.de";
    owner = "jvet";
    repo = "HM";
    tag = "HM-${finalAttrs.version}";
    hash = "sha256-zWBwrnCNKi2sIopdu2XQj/7IoTsJQzlcIFNNKM0glDQ=";
  };

  patches = [
    (fetchpatch {
      name = "fix-building-on-arm.patch";
      url = "https://vcgit.hhi.fraunhofer.de/jvet/HM/-/commit/fd37cd88f557478b591dc0b9157d027354d82e2f.patch";
      hash = "sha256-xP54lBvDabc9Dy1UklH2BJH7fUGLTA4sf9WLt7WzoU8=";
    })
  ];

  cmakeFlags = [
    (lib.cmakeBool "HIGH_BITDEPTH" true)
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    llvmPackages.openmp
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-Wno-error=array-bounds"
    ]
    ++ lib.optionals stdenv.cc.isClang [
      "-Wno-error=bitwise-instead-of-logical"
      "-Wno-error=missing-braces"
    ]
  );

  installPhase = ''
    runHook preInstall

    install -Dm 755 -t $out/bin ../bin/umake/*/*/release/*

    runHook postInstall
  '';

  strictDeps = true;

  passthru = {
    updateScript = gitUpdater { rev-prefix = "HM-"; };
  };

  meta = {
    description = "Reference software for HEVC";
    homepage = "https://vcgit.hhi.fraunhofer.de/jvet/HM";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
