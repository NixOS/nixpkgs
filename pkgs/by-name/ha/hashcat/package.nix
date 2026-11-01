{
  lib,
  stdenv,
  addDriverRunpath,
  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  fetchurl,
  makeWrapper,
  minizip,
  opencl-headers,
  ocl-icd,
  perl,
  python3,
  rocmPackages,
  rocmSupport ? config.rocmSupport,
  xxhash,
  zlib,
  libiconv,
  versionCheckHook,
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

  postPatch = ''
     # MACOSX_DEPLOYMENT_TARGET is defined by the environment
     # Remove hardcoded paths on darwin
    substituteInPlace src/Makefile \
      --replace-fail "export MACOSX_DEPLOYMENT_TARGET" "#export MACOSX_DEPLOYMENT_TARGET" \
      --replace-fail "/usr/bin/sed" "sed" \
      --replace-fail '-i ""' '-i'
  '';

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals (cudaSupport || rocmSupport) [
    addDriverRunpath
  ];

  buildInputs = [
    minizip
    opencl-headers
    perl
    (python3.withPackages (
      ps: with ps; [
        leveldb # Required for bitwarden2hashcat.py, leveldb-0.201 not supported for interpreter python3.14
        protobuf
        pyasn1
        pycryptodome
        python-snappy
        simplejson
      ]
    ))
    xxhash
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "COMPTIME=1337"
    "VERSION_TAG=${finalAttrs.version}"
    "USE_SYSTEM_OPENCL=1"
    "USE_SYSTEM_XXHASH=1"
    "USE_SYSTEM_ZLIB=1"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform == stdenv.buildPlatform) [
    "IS_APPLE_SILICON='${if stdenv.hostPlatform.isAarch64 then "1" else "0"}'"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    "IS_AARCH64=1"
  ];

  enableParallelBuilding = true;

  preFixup = ''
    for f in $out/share/hashcat/OpenCL/*.cl; do
      # Rewrite files to be included for compilation at runtime for opencl offload
      sed "s|#include \"\(.*\)\"|#include \"$out/share/hashcat/OpenCL/\1\"|g" -i "$f"
      sed "s|#define COMPARE_\([SM]\) \"\(.*\.cl\)\"|#define COMPARE_\1 \"$out/share/hashcat/OpenCL/\2\"|g" -i "$f"
    done
  '';

  postFixup =
    let
      LD_LIBRARY_PATH = lib.makeLibraryPath (
        [
          ocl-icd
        ]
        ++ lib.optionals cudaSupport [
          cudaPackages.cuda_nvrtc
          cudaPackages.cuda_cudart
        ]
        ++ lib.optionals rocmSupport [
          rocmPackages.clr
        ]
      );
    in
    ''
      wrapProgram $out/bin/hashcat \
        --prefix LD_LIBRARY_PATH : ${lib.escapeShellArg LD_LIBRARY_PATH}
    ''
    + lib.optionalString (cudaSupport || rocmSupport) ''
      for program in $out/bin/hashcat $out/bin/.hashcat-wrapped; do
        isELF "$program" || continue
        addDriverRunpath "$program"
      done
    '';

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
