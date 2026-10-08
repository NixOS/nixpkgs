{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fuse3,
  readline,
  pkg-config,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "android-file-transfer";
  version = "4.5-unstable-2026-04-17";

  src = fetchFromGitHub {
    owner = "whoozle";
    repo = "android-file-transfer-linux";
    # tag = "v${finalAttrs.version}";
    # Switch to unreleased version for recent fixes, especially to fix the build on Darwin
    # https://github.com/whoozle/android-file-transfer-linux/pull/360
    # TODO: Switch back when the next version releases
    rev = "88926930db41238c7b4d7237fc5849b9586cc7b8";
    sha256 = "sha256-rk1QXq8JiLRZu+dz9HvWkOj5JyaLMXzTybByl46obE8=";
  };

  patches = [ ./darwin-dont-vendor-dependencies.patch ];

  nativeBuildInputs = [
    cmake
    readline
    pkg-config
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    fuse3
    qt6.qtbase
    qt6.qttools
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/*.app $out/Applications
  '';

  meta = {
    description = "Reliable MTP client with minimalistic UI";
    homepage = "https://whoozle.github.io/android-file-transfer-linux/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.xaverdh ];
    platforms = lib.platforms.unix;
  };
})
