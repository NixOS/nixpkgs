{
  lib,
  stdenv,

  nix-update-script,
  addDriverRunpath,
  fetchFromGitHub,
  makeWrapper,
  xxHash,
  autoAddDriverRunpath,

  # test foo
  testers,
  nixosTests,
  hashcat,
  # test foo stop

  # cuda foo
  hashcat-cuda ? config.cudaSupport,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
  # cuda foo stop

  # ROCm foo
  hashcat-rocm ? config.rocmSupport,
  rocmSupport ? config.rocmSupport,
  # buildEnv,
  # linkFarm,
  rocmPackages ? { },
  # ROCm foo stop

  # opencl foo
  ocl-icd,
  opencl-headers,
  # opencl foo stop

  # Darwin / arm foo stop
  OpenCL ? stdenv.hostPlatform.isDarwin,
  Foundation ? stdenv.hostPlatform.isDarwin,
  IOKit ? stdenv.hostPlatform.isDarwin,
  Metal ? stdenv.hostPlatform.isDarwin,
  libiconv ? stdenv.hostPlatform.isDarwin,
  # Darwin / arm foo stop

  config,
  # one of `"opencl" "rocm" "cuda" ]`
  acceleration ? null,
}:

assert builtins.elem acceleration [
  null
  false
  "rocm"
  "cuda"
];

let
  pname = "hashcat";
  version = "6.2.6";

  src = fetchFromGitHub {
    owner = "hashcat";
    repo = "${pname}";
    rev = "6716447dfce969ddde42a9abe0681500bee0df48";
    hash = "sha256-adDVPpeVAw917IpFeOq2FT/VUaKHQh1k8ljgDEcWi/k=";
  };

  validateFallback = lib.warnIf (config.rocmSupport && config.cudaSupport) (lib.concatStrings [
    "both `nixpkgs.config.rocmSupport` and `nixpkgs.config.cudaSupport` are enabled, "
    "but they are mutually exclusive; falling back to cpu"
  ]) (!(config.rocmSupport && config.cudaSupport));

  rocmRequested = shouldEnable "rocm" rocmSupport;
  cudaRequested = shouldEnable "cuda" cudaSupport;
  shouldEnable =
    mode: fallback: (acceleration == mode) || (fallback && acceleration == null && validateFallback);

  enableRocm = rocmRequested && stdenv.hostPlatform.isLinux;
  enableCuda = cudaRequested && stdenv.hostPlatform.isLinux;

  openclLibs = [
    ocl-icd
    opencl-headers
  ];

  DarwinLibs = [
    OpenCL
    Foundation
    IOKit
    Metal
    libiconv
  ];

  rocmLibs = [
    rocmPackages.clr
    rocmPackages.hipblas
    rocmPackages.rocblas
    rocmPackages.rocsolver
    rocmPackages.rocsparse
    rocmPackages.rocm-device-libs
    rocmPackages.rocm-smi
  ];
  # rocmClang = linkFarm "rocm-clang" { llvm = rocmPackages.llvm.clang; };
  # rocmPath = buildEnv {
  # name = "rocm-path";
  # paths = rocmLibs ++ [ rocmClang ];
  # };

  cudaLibs = [ addDriverRunpath ];

in
stdenv.mkDerivation {
  inherit pname version src;
  nativeBuildInputs =
    [
      makeWrapper
      autoAddDriverRunpath
    ]
    ++ [ openclLibs ] ++ lib.optionals enableRocm [ rocmLibs ] ++ lib.optionals enableCuda [ cudaLibs ];

  buildInputs =
    [
      xxHash
    ]
    ++ [ openclLibs ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ DarwinLibs ]
    ++ lib.optionals rocmRequested [ rocmLibs ]
    ++ lib.optionals cudaRequested [ cudaLibs ];

  patches = lib.optionals enableRocm [
    ./rocm1.patch
    ./rocm2.patch
  ];
  makeFlags =
    [
      "PREFIX=${placeholder "out"}"
      "COMPTIME=1337"
      "VERSION_TAG=${version}"
      "USE_SYSTEM_OPENCL=1"
      "USE_SYSTEM_XXHASH=1"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform == stdenv.buildPlatform) [
      "IS_APPLE_SILICON='${if stdenv.hostPlatform.isAarch64 then "1" else "0"}'"
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
        ++ lib.optionals cudaRequested [
          "${cudaPackages.cudatoolkit}/lib"
        ]
        ++ lib.optionals rocmRequested [
          "${rocmPackages.rocblas}/lib"
        ]
      );
    in
    ''
      wrapProgram $out/bin/hashcat \
        --prefix LD_LIBRARY_PATH : ${lib.escapeShellArg LD_LIBRARY_PATH}
    ''
    + lib.optionalString cudaRequested ''
      for program in $out/bin/hashcat $out/bin/.hashcat-wrapped; do
        isELF "$program" || continue
        addDriverRunpath "$program"
      done
    ''
    + lib.optionalString rocmRequested ''
      for program in $out/bin/hashcat $out/bin/.hashcat-wrapped; do
        isELF "$program" || continue
        addDriverRunpath "$program"
      done
    '';

  passthru = {
    tests =
      {
        inherit hashcat;
        version = testers.testVersion {
          inherit version;
          package = hashcat;
        };
      }
      // lib.optionalAttrs stdenv.hostPlatform.isLinux {
        inherit hashcat-rocm hashcat-cuda;
        service = nixosTests.hashcat;
        service-cuda = nixosTests.hashcat-cuda;
        service-rocm = nixosTests.hashcat-rocm;
      };
  } // lib.optionalAttrs (!enableRocm && !enableCuda) { updateScript = nix-update-script { }; };

  meta = with lib; {
    description =
      "Fast password cracker"
      + lib.optionalString rocmRequested ", usng ROCM for AMD GPU acceleration"
      + lib.optionalString cudaRequested ", usng CUDA for NVIDIA GPU acceleration";
    mainProgram = "hashcat";
    changelog = "https://github.com/hashcat/hashcat/releases/tag/${version}";
    homepage = "https://hashcat.net/hashcat/";
    license = licenses.mit;
    platforms = if (rocmRequested || cudaRequested) then platforms.linux else platforms.unix;
    maintainers = with maintainers; [
      felixalbrigtsen
      zimbatm
      Makuru
    ];
  };
}
