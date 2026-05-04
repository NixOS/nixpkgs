{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  testers,

  static ? stdenv.hostPlatform.isStatic,

  lz4,
  zlib-ng,
  zstd,
}:

let
  zfpVersion = "1.0.1";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "c-blosc2";
  version = "3.0.2";

  srcs = [
    (fetchFromGitHub {
      owner = "Blosc";
      repo = "c-blosc2";
      rev = "v${finalAttrs.version}";
      sha256 = "sha256-YR8iArp81QK12RazxYMVq3YEFaR24TFKCHDkvjwJIhE=";
    })
    (fetchFromGitHub {
      name = "zfp";
      owner = "LLNL";
      repo = "zfp";
      rev = zfpVersion;
      hash = "sha256-iZxA4lIviZQgaeHj6tEQzEFSKocfgpUyf4WvUykb9qk=";
    })
  ];
  sourceRoot = "source";

  # perform parameter expansion for cmakeFlags
  preUnpack =
    let
      cmakeFlags = toString [
        (lib.cmakeBool "BUILD_STATIC" static)
        (lib.cmakeBool "BUILD_SHARED" (!static))

        (lib.cmakeBool "PREFER_EXTERNAL_LZ4" true)
        (lib.cmakeBool "PREFER_EXTERNAL_ZLIB" true)
        (lib.cmakeBool "PREFER_EXTERNAL_ZSTD" true)

        (lib.cmakeBool "BUILD_EXAMPLES" false)
        (lib.cmakeBool "BUILD_BENCHMARKS" false)
        (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)

        (lib.cmakeFeature "BLOSC_ZFP_SOURCE_DIR" "$PWD/zfp")
      ];
    in
    ''
      export cmakeFlags="${cmakeFlags}"
    '';
  postUnpack = ''
    # ensure our separately pinned versions correspond to those in source
    if ! grep -F 'BLOSC_ZFP_VERSION "${zfpVersion}"' source/CMakeLists.txt ; then
      echo 'Expected to find BLOSC_ZFP_VERSION "${zfpVersion}" in source/CMakeLists.txt:' \
        'has zfp source been updated to match pinned version?'
      exit 1
    fi
  '';

  # https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    sed -i -E \
      -e '/^libdir[=]/clibdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      -e '/^includedir[=]/cincludedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@' \
      blosc2.pc.in
  '';

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    lz4
    zlib-ng
    zstd
  ];

  doCheck = !static;
  # possibly https://github.com/Blosc/c-blosc2/issues/432
  enableParallelChecking = false;

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "Blosc2" ];
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Fast, compressed, persistent binary data store library for C";
    homepage = "https://www.blosc.org";
    changelog = "https://github.com/Blosc/c-blosc2/releases/tag/v${finalAttrs.version}";
    pkgConfigModules = [ "blosc2" ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ris ];
  };
})
