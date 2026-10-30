{
  lib,
  stdenv,
  addDriverRunpath,
  autoPatchelfHook,
  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  fetchurl,
  libiconv,
  ocl-icd,
  opencl-headers,
  perl,
  python3,
  rocmPackages,
  rocmSupport ? config.rocmSupport,
  versionCheckHook,
  xz,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hashcat";
  version = "8.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://hashcat.net/files/hashcat-${finalAttrs.version}.tar.gz";
    hash = "sha256-1qdTPh4lCiNqi5nQtyXN122P3OdEx+6ssr9CIQ/kdhs=";
  };

  nativeBuildInputs = lib.optional (!stdenv.hostPlatform.isDarwin) autoPatchelfHook;

  buildInputs = [
    opencl-headers
    perl
    (python3.withPackages (
      ps: with ps; [
        # leveldb # Required for bitwarden2hashcat.py, broken since python 3.12 https://github.com/NixOS/nixpkgs/pull/342756
        protobuf
        pyasn1
        pycryptodome
        python-snappy
        simplejson
      ]
    ))
    zlib
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "COMPTIME=1337"
    "VERSION_TAG=${finalAttrs.version}"
    "USE_SYSTEM_OPENCL=1"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform == stdenv.buildPlatform) [
    "IS_APPLE_SILICON='${if stdenv.hostPlatform.isAarch64 then "1" else "0"}'"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    "IS_AARCH64=1"
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace src/ext_iconv.c \
      --replace-fail \
        '/usr/lib/libiconv.2.dylib' \
        '${libiconv}/lib/libiconv2.dylib'
  '';

  appendRunpaths =
    (
      map (pkg: (lib.getLib pkg) + "/lib") [
        libiconv
        ocl-icd
        xz
        zlib
        zstd
      ]
      ++ lib.optionals cudaSupport [
        cudaPackages.cuda_nvrtc
      ]
      ++ lib.optionals rocmSupport [
        rocmPackages.clr
      ]
    )
    ++ [
      "${addDriverRunpath.driverLink}/lib"
    ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Fast password cracker";
    mainProgram = "hashcat";
    homepage = "https://hashcat.net/hashcat/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      felixalbrigtsen
      zimbatm
    ];
  };
})
