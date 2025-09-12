{
  runCommand,
  makeWrapper,
  buildEnv,
  fetchFromGitHub,
  gcc12Stdenv,
  lib,
  pkgsi686Linux,
  pugixml,
  libmpc,
  gmp,
  mpfr,
  boost,
  libxml2,
  xz,
  zlib,
  icu,
  suitesparse,
  mpfi,
  glpk,
  autoconf,
  autoconf-archive,
  automake,
  libtool,
  bison,
  doxygen,
  flex,
  graphviz,
  verilog,
  verilator,
  gmpxx,
  buddy,
  bash,
  git,
  # 32bit Clang with a supported major version
  clangFrontends ? [ pkgsi686Linux.llvmPackages_16 ],
  # 32bit GCC with a supported major version
  gccFrontends ? [ pkgsi686Linux.gcc8 ],
}:
let
  # bambu supports many different GCC and clang versions as frontends.
  # See: https://github.com/ferrandi/PandA-bambu/blob/04123a3edb37040db52c44f6591006391cf4a90b/configure.ac#L1218-L1236
  #
  # However many of the older versions appear currently broken. This package
  # only supports versions newer than clang 7 or gcc 6 which are verified to
  # actually work. Clang 14 and 15 were never supported and clang 9 is broken.
  supportedLlvmMajorVersions = [
    "7"
    "8"
    "10"
    "11"
    "12"
    "13"
    "16"
  ];
  supportedGccMajorVersions = [
    "6"
    "7"
    "8"
  ];

  pugixmlWithHeaderOnlySupport = pugixml.overrideAttrs (oldAttrs: {
    # The pugixml library includes the pugixml.cpp file from the pugixml.hpp header
    # file if the PUGIXML_HEADER_ONLY macro is defined.
    postInstall = ''
      cp $src/src/pugixml.cpp $out/include
    '';
  });

  wrapBinFiles = gcc32bit: extraLib: extraDev: ''
    for f in $out/bin/*; do
        if [ -f "$f" ]; then
            wrapProgram "$f" \
              --set AR_FOR_TARGET ar \
              --set AS_FOR_TARGET as \
              --set CC_FOR_TARGET gcc \
              --set CXX_FOR_TARGET g++ \
              --set LD_FOR_TARGET ld \
              --set NIX_BINTOOLS_FOR_TARGET ${gcc32bit.bintools} \
              --set NIX_BINTOOLS_WRAPPER_TARGET_TARGET_i686_unknown_linux_gnu 1 \
              --set NIX_CC_FOR_TARGET ${gcc32bit} \
              --set NIX_CC_WRAPPER_TARGET_TARGET_i686_unknown_linux_gnu 1 \
              --set NM_FOR_TARGET nm \
              --set OBJCOPY_FOR_TARGET objcopy \
              --set OBJDUMP_FOR_TARGET objdump \
              --set RANLIB_FOR_TARGET ranlib \
              --set READELF_FOR_TARGET readelf \
              --set SIZE_FOR_TARGET size \
              --set STRINGS_FOR_TARGET strings \
              --set STRIP_FOR_TARGET strip \
              --prefix HOST_PATH ":" ${gcc32bit.bintools}/bin \
              --prefix HOST_PATH ":" ${gcc32bit}/bin \
              --prefix PATH ":" ${gcc32bit.bintools}/bin \
              --prefix PATH ":" ${gcc32bit}/bin \
              --prefix NIX_LDFLAGS_FOR_TARGET " " "${
                lib.concatStringsSep " " (
                  map (x: "-L${lib.getLib x}/lib") (
                    extraLib
                    ++ [
                      pkgsi686Linux.buddy
                      libmpc
                      gmp
                      mpfr
                      boost
                      libxml2
                      xz
                      zlib
                      icu
                      suitesparse
                      mpfi
                      glpk
                    ]
                  )
                )
              }" \
              --prefix NIX_CFLAGS_COMPILE_FOR_TARGET " " "${
                lib.concatStringsSep " " (
                  map (x: "-I${lib.getDev x}/include") (
                    extraDev
                    ++ [
                      pkgsi686Linux.buddy
                      libmpc
                      gmp
                      mpfr
                      boost
                      libxml2
                      xz
                      zlib
                      icu
                      suitesparse
                      mpfi
                      glpk
                      pugixmlWithHeaderOnlySupport
                      gcc32bit.cc
                    ]
                  )
                )
              }"
        fi
      done
  '';
  wrapGcc =
    gcc:
    runCommand (gcc.name + "-with-libs") { nativeBuildInputs = [ makeWrapper ]; } ''
      mkdir $out
      ln -s ${gcc}/* $out
      rm $out/bin
      mkdir $out/bin
      ln -s ${gcc}/bin/* $out/bin

      ${wrapBinFiles gcc [ gcc.cc ] [ ]}
    '';

  # GCC used for libs and bintools for clang frontends
  i686gcc = if gccFrontends != [ ] then builtins.head gccFrontends else pkgsi686Linux.gcc8;

  # Combines clang and llvm binaries into the same directory
  # This is necessary because bambu finds the LLVM tools by searching in the llvm directory
  combineClangAndLLVM =
    llvmPackages:
    buildEnv {
      name = "clang-with-llvm-" + llvmPackages.release_version;
      paths = [
        llvmPackages.clang
        llvmPackages.clang.cc.libllvm
      ];

      nativeBuildInputs = [ makeWrapper ];

      postBuild = ''
        ln -s ${llvmPackages.clang}/bin/clang++ $out/bin/clang-cpp

        ${wrapBinFiles i686gcc
          [
            llvmPackages.clang
            llvmPackages.clang.cc.libllvm
          ]
          [
            llvmPackages.clang.cc
            llvmPackages.clang.cc.libllvm
          ]
        }
      '';
    };

  clangFrontendsFlags = builtins.map (
    llvmPackages:
    ''--with-clang${lib.versions.major llvmPackages.clang.version}=${combineClangAndLLVM llvmPackages}/bin/clang ''
  ) clangFrontends;
  gccFrontendsFlags = builtins.map (
    gcc: ''--with-gcc${lib.versions.major gcc.version}=${wrapGcc gcc}/bin/gcc ''
  ) gccFrontends;
in

# Assert that there is at least one clang and GCC frontend specified
assert lib.assertMsg (
  builtins.length clangFrontendsFlags != 0
) "There needs to be at least one clang frontend specified";
assert lib.assertMsg (
  builtins.length gccFrontendsFlags != 0
) "There needs to be at least one GCC frontend specified";

# Assert that the passed clang and GCC frontends are i686
assert builtins.all (
  llvmPackages:
  lib.assertMsg (llvmPackages.clang.stdenv.hostPlatform.system == "i686-linux")
    "Bambu frontends have to be i686 but ${llvmPackages.clang.name} is ${llvmPackages.clang.stdenv.hostPlatform.system}"
) clangFrontends;
assert builtins.all (
  gcc:
  lib.assertMsg (
    gcc.stdenv.hostPlatform.system == "i686-linux"
  ) "Bambu frontends have to be i686 but ${gcc.name} is ${gcc.stdenv.hostPlatform.system}"
) gccFrontends;

# Assert that the clang and GCC frontends versions are compatible with bambu
assert builtins.all (
  llvmPackages:
  lib.assertMsg (builtins.elem (lib.versions.major llvmPackages.clang.version) supportedLlvmMajorVersions) "Clang version ${llvmPackages.clang.version} is not supported as a frontend by bambu. The following major clang versions are supported: ${builtins.concatStringsSep " " supportedLlvmMajorVersions}"
) clangFrontends;
assert builtins.all (
  gcc:
  lib.assertMsg (builtins.elem (lib.versions.major gcc.version) supportedGccMajorVersions) "GCC version ${gcc.version} is not supported as a frontend by bambu. The following major GCC versions are supported: ${builtins.concatStringsSep " " supportedGccMajorVersions}"
) gccFrontends;

# Assert that there is only one compiler frontend for each major version of the compiler
let
  passedClangVersions = builtins.map (llvmPackages: llvmPackages.clang.version) clangFrontends;
  duplicateClangVersion = lib.lists.findFirst (
    clangVersion:
    (builtins.length (
      builtins.filter (
        otherClangVersion: (lib.versions.major clangVersion) == (lib.versions.major otherClangVersion)
      ) passedClangVersions
    )) > 1
  ) null passedClangVersions;
  passedGccVersions = builtins.map (gcc: gcc.version) gccFrontends;
  duplicateGccVersion = lib.lists.findFirst (
    gccVersion:
    (builtins.length (
      builtins.filter (
        otherGccVersion: (lib.versions.major gccVersion) == (lib.versions.major otherGccVersion)
      ) passedGccVersions
    )) > 1
  ) null passedGccVersions;
in
assert lib.assertMsg (duplicateClangVersion == null)
  "Multiple clang frontends with the same major version (${lib.versions.major duplicateClangVersion}) are not supported by bambu. You passed packages with the following versions: ${
    builtins.concatStringsSep " " (
      builtins.filter (
        clangVersion: (lib.versions.major clangVersion) == (lib.versions.major duplicateClangVersion)
      ) passedClangVersions
    )
  }";

assert lib.assertMsg (duplicateGccVersion == null)
  "Multiple gcc frontends with the same major version (${lib.versions.major duplicateGccVersion}) are not supported by bambu. You passed packages with the following versions: ${
    builtins.concatStringsSep " " (
      builtins.filter (
        gccVersion: (lib.versions.major gccVersion) == (lib.versions.major duplicateGccVersion)
      ) passedGccVersions
    )
  }";

gcc12Stdenv.mkDerivation rec {
  pname = "bambu-unwrapped";
  version = "2024.03";

  src = fetchFromGitHub {
    owner = "ferrandi";
    repo = "PandA-bambu";
    rev = "v${version}";
    hash = "sha256-TPcVrQqk2SHHTYrBwpl1f8YM5qONEpRwcAetmFAfFWM=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    libtool
    bison
    doxygen
    flex
    graphviz
    verilog
    verilator
    git
  ];

  buildInputs = [
    boost
    buddy
    libmpc
    mpfr
    libxml2
    xz
    mpfi
    zlib
    icu
    suitesparse
    glpk
    gmp
    gmpxx
    pugixmlWithHeaderOnlySupport
  ];

  configureFlags = [
    "--enable-shared=yes"
    "--disable-allstatic"
    "--enable-bambu"
    "--disable-flopoco"
    "--program-prefix="
    "--program-suffix="
  ] ++ gccFrontendsFlags ++ clangFrontendsFlags;
  configureScript = "../configure";
  dontFixLibtool = true;
  dontAddDisableDepTrack = true;
  enableParallelBuilding = true;

  prePatch = ''
    NIX_BUILD_CORES=4
    export NIX_BUILD_CORES=4

    git branch -m '${version}'
  '';

  postPatch = ''
    # There are also some calls to /bin/bash that are in strings used to generated
    # scripts that will be executed at runtime. These are patched here.
    find . -type f -exec sed -i 's|/bin/bash|${bash}/bin/bash|g' {} +
    # Patch all remaining shebangs
    patchShebangs --host .
  '';

  preConfigure = ''
    NIX_BUILD_CORES=4
    export NIX_BUILD_CORES=4

    make -f Makefile.init
    mkdir -p ./build
    cd ./build
  '';

  preBuild = ''
    NIX_BUILD_CORES=4
    export NIX_BUILD_CORES=4
  '';

  meta = with lib; {
    description = "A research environment for high-level synthesis";
    longDescription = ''
      A research environment to experiment with new ideas across HLS, high-level verification and debugging, FPGA/ASIC design, design flow space exploration, and parallel hardware accelerator design.
    '';
    homepage = "https://panda.dei.polimi.it/";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "bambu";
    maintainers = with maintainers; [ zebreus ];
  };
}
