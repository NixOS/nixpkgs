{
  lib,
  stdenv,
  fetchFromGitHub,

  autoconf,
  automake,
  libtool,
  pkg-config,

  libimobiledevice,
  libplist,
  libusb1,
  openssl,

  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ios-webkit-debug-proxy";
  version = "1.9.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "ios-webkit-debug-proxy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-94gYTv5v4YNwbiUJ/9PIHU+Bnvf5uN12+oMFWKj+J1Y=";
  };

  patches = [
    # Examples compilation breaks with --disable-static, see https://github.com/google/ios-webkit-debug-proxy/issues/399
    ./0001-Don-t-compile-examples.patch
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];

  buildInputs = [
    libimobiledevice
    libplist
    libusb1
    openssl
  ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  enableParallelBuilding = true;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = with lib; {
    description = "DevTools proxy (Chrome Remote Debugging Protocol) for iOS devices (Safari Remote Web Inspector)";
    longDescription = ''
      The ios_webkit_debug_proxy (aka iwdp) proxies requests from usbmuxd
      daemon over a websocket connection, allowing developers to send commands
      to MobileSafari and UIWebViews on real and simulated iOS devices.
    '';
    homepage = "https://github.com/google/ios-webkit-debug-proxy";
    changelog = "https://github.com/google/ios-webkit-debug-proxy/releases/tag/${finalAttrs.src.rev}";
    license = licenses.bsd3;
    mainProgram = "ios_webkit_debug_proxy";
    maintainers = with maintainers; [
      abustany
      paveloom
    ];
  };
})
