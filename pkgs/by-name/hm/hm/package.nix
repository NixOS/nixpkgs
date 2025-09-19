{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  cmake,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hm";
  version = "18.0";

  src = fetchFromGitHub {
    owner = "johnrichardrinehart";
    repo = "HM";
    rev = "f3947be0720bfd9ce3312478d64cd35a619c5eae";
    hash = "sha256-kY7YE+S1NJs9yjUnVKjZ8jbIJm/nv/s0DNmNZej66b8=";
  };

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
