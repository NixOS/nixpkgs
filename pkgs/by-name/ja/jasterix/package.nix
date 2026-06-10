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
  onetbb,
  openssl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jasterix";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "OpenATSGmbH";
    repo = "jASTERIX";
    tag = "v${finalAttrs.version}";
    hash = "sha256-df5tByZwtQLdV0UlSo1WkgyoF3hReU/mN74V2WL6zoI=";
  };

  patches = [
    (fetchpatch {
      name = "jasterix-fix-tests.patch";
      url = "https://github.com/OpenATSGmbH/jASTERIX/commit/b79e59c042ebb7eee31f50a7ed48840bcec50429.patch";
      hash = "sha256-V0/nMJGb8ZB/Z6bKvyZnic57HXAsUAHXgyVq+D4yFDw=";
    })
  ];

  # Disable boost-stacktrace_backtrace, which is an optional dependency and not yet available in Nix.
  postPatch = ''
    sed -i 's/\(find_package .*\) stacktrace_backtrace/\1/' CMakeLists.txt
    sed -i 's/BOOST_STACKTRACE_USE_BACKTRACE/#BOOST_STACKTRACE_USE_BACKTRACE/' CMakeLists.txt
    sed -i 's/BOOST_STACKTRACE_LINK/#BOOST_STACKTRACE_LINK/' CMakeLists.txt
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_STATIC" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "WITH_UNIT_TESTS" finalAttrs.doCheck)
  ];

  buildInputs = [
    boost.dev
    catch2_3
    libarchive.dev
    libpcap
    log4cpp
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
