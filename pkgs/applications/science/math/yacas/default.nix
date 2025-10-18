{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  perl,
  enableGui ? false,
  qtbase,
  wrapQtAppsHook,
  qtwebengine,
  enableJupyter ? true,
  boost,
  jsoncpp,
  openssl,
  zmqpp,
  enableJava ? false,
  openjdk,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "yacas";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "grzegorzmazur";
    repo = "yacas";
    rev = "v${version}";
    sha256 = "0dqgqvsb6ggr8jb3ngf0jwfkn6xwj2knhmvqyzx3amc74yd3ckqx";
  };

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DENABLE_CYACAS_GUI=${if enableGui then "ON" else "OFF"}"
    "-DENABLE_CYACAS_KERNEL=${if enableJupyter then "ON" else "OFF"}"
    "-DENABLE_JYACAS=${if enableJava then "ON" else "OFF"}"
    "-DENABLE_CYACAS_UNIT_TESTS=ON"
  ];
  patches = [
    # upstream issue: https://github.com/grzegorzmazur/yacas/issues/340
    # Upstream patch which doesn't apply on 1.9.1 is:
    # https://github.com/grzegorzmazur/yacas/pull/342
    ./jsoncpp-fix-include.patch
    # Fixes testing - https://github.com/grzegorzmazur/yacas/issues/339
    # PR: https://github.com/grzegorzmazur/yacas/pull/343
    (fetchpatch {
      url = "https://github.com/grzegorzmazur/yacas/commit/8bc22d517ecfdde3ac94800dc8506f5405564d48.patch";
      hash = "sha256-aPO5T8iYNkGtF8j12YxNJyUPJJPKrXje1DmfCPt317A=";
    })
  ];
  preCheck = ''
    patchShebangs ../tests/test-yacas
  '';
  nativeCheckInputs = [
    gtest
  ];
  doCheck = true;

  nativeBuildInputs = [
    cmake
    # Perl is only for the documentation
    perl
  ]
  ++ lib.optionals enableJava [
    openjdk
  ];
  buildInputs = [
  ]
  ++ lib.optionals enableGui [
    qtbase
    wrapQtAppsHook
    qtwebengine
  ]
  ++ lib.optionals enableJupyter [
    boost
    jsoncpp
    openssl
    zmqpp
  ];

  meta = {
    description = "Easy to use, general purpose Computer Algebra System, optionally with GUI";
    homepage = "http://www.yacas.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
}
