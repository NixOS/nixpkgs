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

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "-msse4.1" ""
  '';

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
      "-Wno-error=nontrivial-memcall"
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
