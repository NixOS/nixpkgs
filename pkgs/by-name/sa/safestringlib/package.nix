{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation {
  pname = "safestringlib";
  # Latest release is 1.2.0 and has compilation issues
  version = "1.2.0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "safestringlib";
    rev = "e99c03cfafdce5311c4dbf1fd3f916ccc6e300be";
    hash = "sha256-d+6YDtMtdaS2eW0eIfuwzdQRiExsoexL3fKj7C2zENM=";
  };

  outputs = [
    "out"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_UNITTESTS" true)
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  patches = [
    # https://github.com/intel/safestringlib/issues/74
    (fetchpatch {
      name = "darwin-fix";
      url = "https://github.com/intel/safestringlib/pull/75/commits/3ff9c6234be7dd4ee1dd5cdc2ccbb2c7541adfec.patch";
      hash = "sha256-4HS7XyKPQSmKczaMCi1s6NxgTNzRZXTds2CXBTbpuAM=";
    })
  ];

  # see https://github.com/bwa-mem2/bwa-mem2/issues/93
  # Skip wmemset too
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i 's/memset_s/memset8_s/g' include/safe_mem_lib.h
    sed -i 's/memset_s/memset8_s/g' safeclib/memset16_s.c
    sed -i 's/memset_s/memset8_s/g' safeclib/memset32_s.c
    sed -i 's/memset_s/memset8_s/g' safeclib/memset_s.c
    sed -i 's/memset_s/memset8_s/g' safeclib/wmemset_s.c
    sed -i 's/ memset_s/ memset8_s/g' unittests/*.c
    sed -i 's/ wmemset_s/ wmemset8_s/g' unittests/*.c
  '';

  checkPhase = ''
    runHook preCheck
    cd unittests
    ./safestring_test
    runHook postCheck
  '';
  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp ../libsafestring_static.a $out/lib/libsafestring.a
    mkdir -p $out/
    cp -r ../../include  $out/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/intel/safestringlib";
    description = "Safer replacements for C library functions that prevent serious security vulnerabilities";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ apraga ];
  };
}
