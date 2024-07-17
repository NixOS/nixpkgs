{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bwa-mem2";
  version = "unstable-2023-03-18";

  src = fetchFromGitHub {
    owner = "bwa-mem2";
    repo = "bwa-mem2";
    rev = "cf4306a47dac35e7e79a9e75398a35f33900cfd0";
    fetchSubmodules = true;
    hash = "sha256-1AYSn7nBrDwbX7oSrdEoa1d3t6xzwKnA0S87Y/XeXJg=";
  };

  buildInputs = [ zlib ];

  # see https://github.com/bwa-mem2/bwa-mem2/issues/93
  postPatch = lib.optionalString stdenv.isDarwin ''
    sed -i 's/memset_s/memset8_s/g' ext/safestringlib/include/safe_mem_lib.h
    sed -i 's/memset_s/memset8_s/g' ext/safestringlib/safeclib/memset16_s.c
    sed -i 's/memset_s/memset8_s/g' ext/safestringlib/safeclib/memset32_s.c
    sed -i 's/memset_s/memset8_s/g' ext/safestringlib/safeclib/memset_s.c
    sed -i 's/memset_s/memset8_s/g' ext/safestringlib/safeclib/wmemset_s.c
  '';

  buildFlags = [
    (
      if stdenv.hostPlatform.sse4_2Support then
        "arch=sse42"
      else if stdenv.hostPlatform.avxSupport then
        "arch=avx"
      else if stdenv.hostPlatform.avx2Support then
        "arch=avx2"
      else if stdenv.hostPlatform.avx512Support then
        "arch=avx512"
      else
        "arch=sse41"
    )
  ];
  enableParallelBuilding = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bwa-mem2* $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Next version of the bwa-mem algorithm in bwa, a software package for mapping low-divergent sequences against a large reference genome";
    mainProgram = "bwa-mem2";
    license = licenses.mit;
    homepage = "https://github.com/bwa-mem2/bwa-mem2/";
    changelog = "https://github.com/bwa-mem2/bwa-mem2/blob/${finalAttrs.src.rev}/NEWS.md";
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ alxsimon ];
  };
})
