{
  boost,
  catch2_3,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  lib,
  libarchive,
  libpcap,
  log4cpp,
  nlohmann_json,
  onetbb,
  openssl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jasterix";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "OpenATSGmbH";
    repo = "jASTERIX";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vYlaN/R2TzEfdnNmfA1XcVl1QXo9cmOT+zPn1a6q+ys=";
  };

  patches = [
    (fetchpatch {
      name = "jasterix-fix-include-json.patch";
      url = "https://github.com/OpenATSGmbH/jASTERIX/pull/51.patch";
      hash = "sha256-ZnbLa1FHBZgo83jKzMUDfcPhSRx+XgJgw3M6zjgy5ZI=";
    })
  ];

  # Disabling boost-stacktrace_backtrace, which is an optional dependency and not yet available in Nix.
  postPatch = ''
    sed -i 's/\(find_package .*\) stacktrace_backtrace/\1/' CMakeLists.txt
    sed -i 's/BOOST_STACKTRACE_USE_BACKTRACE/#BOOST_STACKTRACE_USE_BACKTRACE/' CMakeLists.txt
    sed -i 's/BOOST_STACKTRACE_LINK/#BOOST_STACKTRACE_LINK/' CMakeLists.txt
  '';

  postInstall = ''
    install -d $out/share/jasterix
    cp -rL ../definitions $out/share/jasterix

    install -Dm444 /dev/stdin $dev/lib/pkgconfig/jasterix.pc <<EOF
    prefix=$out
    exec_prefix=\''${prefix}
    libdir=\''${prefix}/lib
    includedir=$dev/include
    datadir=\''${prefix}/share/jasterix

    Name: jASTERIX
    URL: ${finalAttrs.meta.homepage}
    Description: ${finalAttrs.meta.description}
    Version: ${finalAttrs.version}
    Libs: -L\''${libdir} -lboost_filesystem -lboost_iostreams -ljasterix
    Cflags: -I\''${includedir}
    Requires: libcrypto libpcap tbb boost log4cpp
    EOF
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_STATIC" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "WITH_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  buildInputs = [
    boost.dev
    catch2_3
    libarchive.dev
    libpcap
    log4cpp
    nlohmann_json
    onetbb.dev
    openssl.dev
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "C++ Library for EUROCONTROL's ASTERIX to JSON conversion";
    homepage = "https://github.com/OpenATSGmbH/jASTERIX";
    changelog = "https://github.com/OpenATSGmbH/jASTERIX/releases/tag/v${finalAttrs.src.tag}";
    maintainers = [ lib.maintainers.vog ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})
