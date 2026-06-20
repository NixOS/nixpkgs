{
  lib,
  stdenv,
  pkgsCross,
  fetchFromGitHub,
  buildPackages,
  cmake,
  git,
  python3,
  meson,
  ninja,
  tinyxxd,
  sqlite,
  libz,
  ncurses,
  libxml2,
  wine64,
  darwin,
  symlinkJoin,
}:
let
  dxmt-llvm = stdenv.mkDerivation rec {
    pname = "dxmt-llvm";
    version = "15.0.7";

    src = fetchFromGitHub {
      owner = "llvm";
      repo = "llvm-project";
      tag = version;
      hash = "sha256-wjuZQyXQ/jsmvy6y1aksCcEDXGBjuhpgngF3XQJ/T4s=";
    };

    nativeBuildInputs = [
      cmake
      git
      ninja
      python3
    ];

    cmakeFlags = [
      "-DLLVM_ENABLE_ZSTD=OFF"
      "-DLLVM_BUILD_TOOLS=Off"
      "-S ../llvm"
    ];
  };
  inherit (darwin) xcode;

  dxmt = pkgsCross.mingwW64.stdenv.mkDerivation (finalAttrs: {
    pname = "dxmt";
    version = "0.80";

    src = fetchFromGitHub {
      owner = "3shain";
      repo = "dxmt";
      rev = "v${finalAttrs.version}";
      hash = "sha256-HNSKqEYu8se8DyzwRbqfmHRRyBXyW6D5ddPaEdnkuL4=";
      fetchSubmodules = true;
    };

    patches = [
      ./winecrt0.patch
    ];

    postPatch = ''
      substituteInPlace src/airconv/darwin/meson.build --replace-fail -lcurses -lncurses

      sed -e "/find_program('xcrun')/d" \
          -e "s,metalir_generator = generator(xcrun,metalir_generator = generator(find_program('${xcode}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/metal')," \
          -e "s,metallib_generator = generator(xcrun,metallib_generator = generator(find_program('${xcode}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/metallib')," \
          -e "s/'-sdk', 'macosx', 'metal\(lib\)\{0,1\}', //" \
          -i meson.build
    '';

    nativeBuildInputs = [
      meson
      ninja
      tinyxxd
      buildPackages.stdenv.cc
    ];

    buildInputs = [
      sqlite
      libz
      ncurses
      libxml2
    ];

    mesonFlags = [
      (lib.mesonOption "native_llvm_path" "${dxmt-llvm}")
      (lib.mesonOption "wine_install_path" "${wine64}")
    ];

    preBuild = ''
      export HOME=$TMPDIR
    '';

    __structuredAttrs = true;
    strictDeps = true;

    meta = {
      description = "Metal-based translation layer for Direct3D 10/11";
      homepage = "https://github.com/3shain/dxmt";
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.feyorsh ];
      platforms = lib.platforms.windows;
      hydraPlatforms = [ ];
    };
  });
in
symlinkJoin {
  name = "dxmt-${dxmt.version}";

  paths = [ dxmt ];

  passthru = {
    inherit dxmt;
  };

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    inherit (dxmt.meta)
      description
      homepage
      maintainers
      license
      ;
    platforms = [ "x86_64-darwin" ];
    hydraPlatforms = [ ];
  };
}
