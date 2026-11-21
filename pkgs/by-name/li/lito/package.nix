{
  lib,
  llvmPackages_22,
  fetchFromGitHub,
  fetchzip,
  cmake,
  ninja,
  makeWrapper,
  versionCheckHook,
  zstd,
  openssl,
  glibc,
}:

let
  llvmPackages = llvmPackages_22;

  # deps.json is copied from upstream
  deps = lib.mapAttrs (
    _: dep:
    fetchFromGitHub {
      inherit (dep) owner repo rev;
      hash = dep.narHash;
    }
  ) (builtins.fromJSON (builtins.readFile ./deps.json));

  fetchContentSources = deps // {
    lua = fetchzip {
      url = "https://www.lua.org/ftp/lua-5.5.1.tar.gz";
      hash = "sha256-vb3Nt5dMPL/G6L1MmJPGQnQT3F8p6iK6Gu2F/cG00ho=";
    };
  };
in

llvmPackages.libcxxStdenv.mkDerivation (finalAttrs: {
  pname = "lito";
  version = "0.8.8";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "litocpp";
    repo = "lito";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3JIy3fFxzuUmqW0QmttWIAN2UvxtxxHs1GeanAm8HVo=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    makeWrapper
    llvmPackages.lld
  ];

  buildInputs = [
    zstd
    openssl
  ];

  cmakeFlags = [
    # cmake can't find these through the wrapper and LTO needs them
    (lib.cmakeFeature "CMAKE_CXX_COMPILER_AR" "${llvmPackages.llvm}/bin/llvm-ar")
    (lib.cmakeFeature "CMAKE_C_COMPILER_AR" "${llvmPackages.llvm}/bin/llvm-ar")
    (lib.cmakeFeature "CMAKE_CXX_COMPILER_RANLIB" "${llvmPackages.llvm}/bin/llvm-ranlib")
    (lib.cmakeFeature "CMAKE_C_COMPILER_RANLIB" "${llvmPackages.llvm}/bin/llvm-ranlib")
    # clang-scan-deps ignores the wrapper's flags, so it can't find libc++/glibc headers
    (lib.cmakeFeature "CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES" (
      lib.concatStringsSep ";" [
        "${lib.getDev llvmPackages.libcxx}/include/c++/v1"
        "${lib.getDev llvmPackages.libcxx}/include"
        "${lib.getDev glibc}/include"
      ]
    ))
  ]
  ++ lib.mapAttrsToList (
    name: src: lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_${lib.toUpper name}" "${src}"
  ) fetchContentSources;

  # lito looks up clang++, lld and llvm tools in PATH
  postInstall = ''
    wrapProgram $out/bin/lito \
      --prefix PATH : ${
        lib.makeBinPath [
          llvmPackages.clang
          llvmPackages.lld
          llvmPackages.llvm
        ]
      }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  # without this rstd fails: "using declaration referring to 'openat' ... cannot be exported"
  env.NIX_CFLAGS_COMPILE = "-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0";

  meta = {
    description = "Module-first C++ builder and package manager";
    homepage = "https://litocpp.org/";
    changelog = "https://github.com/litocpp/lito/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "lito";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ samirbgno ];
  };
})
