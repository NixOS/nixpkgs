{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  openssl,
  boost,
  testers,
  asioVersion ? "1.36.0",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asio";
  version = asioVersion;

  src = fetchFromGitHub {
    owner = "chriskohlhoff";
    repo = "asio";
    tag = "asio-${lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash =
      {
        # Preserve 1.32.0 because some project depends on asio/io_service.hpp
        "1.32.0" = "sha256-PBoa4OAOOmHas9wCutjz80rWXc3zGONntb9vTQk3FNY=";
        "1.36.0" = "sha256-BhJpE5+t0WXsuQ5CtncU0P8Kf483uFoV+OGlFLc7TpQ=";
      }
      .${asioVersion} or (throw "Unsupported asio version. Please use overrideAttrs directly");
  };

  sourceRoot = "${finalAttrs.src.name}/asio";

  patches = [
    # Linking against `boost_system` fails because the stub compiled library
    # of Boost.System, which has been a header-only library since 1.69, was
    # removed in 1.89.
    # Upstream issue: https://github.com/chriskohlhoff/asio/issues/1716
    ./boost-1.89.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  # Only used for test coverage
  checkInputs = [
    openssl
    boost
  ];

  configureFlags = lib.optionals finalAttrs.finalPackage.doCheck [
    # Only used in tests, "HAVE_BOOST_COROUTINE"
    "--enable-boost-coroutine"

    # There is also the "--with-boost" flag, but
    # after several tests, it doesn't make any difference
    # in the output.
  ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = {
    homepage = "https://think-async.com/Asio";
    description = "Cross-platform C++ library for network and low-level I/O programming";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "asio" ];
  };
})
