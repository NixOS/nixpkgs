{
  lib,
  stdenv,
  addDriverRunpath,
  config,
  cudaPackages_12_4 ? { },
  cudaSupport ? config.cudaSupport,
  fetchurl,
  makeWrapper,
  minizip,
  opencl-headers,
  ocl-icd,
  perl,
  python3,
  xxHash,
  zlib,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "hashcat";
  version = "7.0.0";

  src = fetchurl {
    url = "https://hashcat.net/files/hashcat-${version}.tar.gz";
    sha256 = "sha256-hCtx0NNLAgAFiCR6rp/smg/BMnfyzTpqSSWw8Jszv3U=";
  };

  patches = [
    ./0001-python-shebangs.patch
  ];

  postPatch = ''
     # MACOSX_DEPLOYMENT_TARGET is defined by the enviroment
     # Remove hardcoded paths on darwin
    substituteInPlace src/Makefile \
      --replace "export MACOSX_DEPLOYMENT_TARGET" "#export MACOSX_DEPLOYMENT_TARGET" \
      --replace "/usr/bin/ar" "ar" \
      --replace "/usr/bin/sed" "sed" \
      --replace '-i ""' '-i'
  '';

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals cudaSupport [
    addDriverRunpath
  ];

  buildInputs = [
    minizip
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
    xxHash
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "COMPTIME=1337"
    "VERSION_TAG=${version}"
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
      LD_LIBRARY_PATH = builtins.concatStringsSep ":" (
        [
          "${ocl-icd}/lib"
        ]
        ++ lib.optionals cudaSupport [
          "${cudaPackages_12_4.cudatoolkit}/lib"
        ]
      );
    in
    ''
      wrapProgram $out/bin/hashcat \
        --prefix LD_LIBRARY_PATH : ${lib.escapeShellArg LD_LIBRARY_PATH}
    ''
    + lib.optionalString cudaSupport ''
      for program in $out/bin/hashcat $out/bin/.hashcat-wrapped; do
        isELF "$program" || continue
        addDriverRunpath "$program"
      done
    '';

  meta = with lib; {
    description = "Fast password cracker";
    mainProgram = "hashcat";
    homepage = "https://hashcat.net/hashcat/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      felixalbrigtsen
      zimbatm
    ];
  };
}
