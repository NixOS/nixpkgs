{
  lib,
  fetchFromGitHub,
  llvmPackages,
  cmake,
  makeWrapper,
  versionCheckHook,
  gitUpdater,
}:

llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "clazy";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "clazy";
    tag = finalAttrs.version;
    hash = "sha256-i/tqH2RHU+LwvMFI8ft92j0i04mQxLVIyrGXlqzMGWs=";
  };

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.libclang
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  postInstall = ''
    includePaths() {
      local language=$1
      shift
      local -a paths=() after=()
      while (( $# > 1 )); do
        case $language:$1 in
          *:-isystem|c++:-cxx-isystem) paths+=("$2"); shift ;;
          *:-idirafter) after+=("$2"); shift ;;
        esac
        shift
      done
      paths+=("''${after[@]}")
      local IFS=:
      echo "''${paths[*]}"
    }
    libcPath=$(includePaths c $(<${llvmPackages.clang}/nix-support/${
      llvmPackages.clang.importerFlags.libc or "libc-cflags"
    }))
    cxxPath=$(includePaths c++ $(<${llvmPackages.clang}/nix-support/${
      llvmPackages.clang.importerFlags.cxx or "libcxx-cxxflags"
    }) $(<${llvmPackages.clang}/nix-support/${llvmPackages.clang.importerFlags.libc or "libc-cflags"}))

    wrapProgram $out/bin/clazy \
      --suffix PATH               : "${llvmPackages.clang}/bin/"                            \
      --suffix CPATH              : "$libcPath"                                             \
      --suffix CPATH              : "${llvmPackages.clang}/resource-root/include"           \
      --suffix CPLUS_INCLUDE_PATH : "$cxxPath"                                              \
      --suffix CPLUS_INCLUDE_PATH : "${llvmPackages.clang}/resource-root/include"

    wrapProgram $out/bin/clazy-standalone \
      --suffix CPATH              : "$libcPath"                                             \
      --suffix CPATH              : "${llvmPackages.clang}/resource-root/include"           \
      --suffix CPLUS_INCLUDE_PATH : "$cxxPath"                                              \
      --suffix CPLUS_INCLUDE_PATH : "${llvmPackages.clang}/resource-root/include"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Qt-oriented static code analyzer based on the Clang framework";
    homepage = "https://github.com/KDE/clazy";
    changelog = "https://github.com/KDE/clazy/blob/${finalAttrs.version}/Changelog";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ lib.maintainers.cadkin ];
    platforms = lib.platforms.linux;
  };
})
