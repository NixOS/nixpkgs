{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  libusb1,
  openssl,
  darwin,
  zlib,
  libirecovery,
  libimobiledevice,
  usbmuxd,
  libplist,
  libpng,
  libusbmuxd,
  automake,
  autoconf,
  readline,
  mbedtls,
  xxd,
}:

let

  checkra1n-platforms = {
    x86_64-linux = "linux-x86_64";
    i686-linux = "linux-i86";
    aarch64-linux = "linux-arm64";
    armv7l-linux = "linux-armel";
  };

  checkra1n-platform =
    checkra1n-platforms.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  checkra1n-macos = fetchurl {
    url = "https://assets.checkra.in/downloads/preview/0.1337.3/checkra1n-macos";
    hash = "sha256-O8GgJH3ZeCsY3olF47s7LcdAIIuMePeGNLgKeASp+b4=";
  };
  checkra1n-linux-arm64 = fetchurl {
    url = "https://assets.checkra.in/downloads/preview/0.1337.3/checkra1n-linux-arm64";
    hash = "sha256-B4BTwR6aMB8Ocbh7a4VObIppyHlyMl3QyQ3u66HDy3A=";
  };
  checkra1n-linux-armel = fetchurl {
    url = "https://assets.checkra.in/downloads/preview/0.1337.3/checkra1n-linux-armel";
    hash = "sha256-FdwkP8Dn7nepxcWBRmd3DQK+NK4Swtdyk9UG0YsTCrI=";
  };
  checkra1n-linux-x86 = fetchurl {
    url = "https://assets.checkra.in/downloads/preview/0.1337.3/checkra1n-linux-x86";
    hash = "sha256-VV4aIc5QvtMYJtSc7660vZCZhGzSrAx+4M/mSctYiIc=";
  };
  checkra1n-linux-x86_64 = fetchurl {
    url = "https://assets.checkra.in/downloads/preview/0.1337.3/checkra1n-linux-x86_64";
    hash = "sha256-UxVNh1lM9nxWZZ8kVH8bW7Uzb4TqWMLULyWnst+BqWQ=";
  };

  checkra1n-kpf-pongo = fetchurl {
    url = "https://cdn.nickchan.lol/palera1n/artifacts/kpf/iOS15/checkra1n-kpf-pongo";
    hash = "sha256-2B3t0epbnNyYIqVJj/mduvPqe0C8gekCkIAtclMWTHY=";
  };

  ramdisk-dmg = fetchurl {
    url = "https://cdn.nickchan.lol/palera1n/c-rewrite/deps/ramdisk.dmg";
    hash = "sha256-1k/cLxtWOY6hpX0M9xMOUm0ufKzsGglnR21dgzGQZ4M=";
  };

  binpack-dmg = fetchurl {
    url = "https://cdn.nickchan.lol/palera1n/c-rewrite/deps/binpack.dmg";
    hash = "sha256-rUIjFVtqYm+mamSk+y0p+RzFb4giyrfN9FrHfqJE79M=";
  };

  Pongo-bin = fetchurl {
    url = "https://cdn.nickchan.lol/palera1n/artifacts/kpf/iOS15/Pongo.bin";
    hash = "sha256-go0J/oAd1EuK+UMySTC/TU2rX2zB4vMA8sQPKU8Nzko=";
  };

  checkra1n-binaries = {
    "linux-x86_64" = checkra1n-linux-x86_64;
    "linux-i86" = checkra1n-linux-x86;
    "linux-arm64" = checkra1n-linux-arm64;
    "linux-armel" = checkra1n-linux-armel;
  };

  checkra1n-binary = checkra1n-binaries.${checkra1n-platform};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "palera1n";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "palera1n";
    repo = "palera1n";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7c5upg9DxkDzNln8bmGYf+ko68wUwWoXp637WtqfJZo=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libusb1
      openssl
      zlib
      libirecovery
      libimobiledevice
      usbmuxd
      libplist.out
      libpng
      libusbmuxd
      automake
      autoconf
      readline
      mbedtls
      xxd
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.Security
    ];

  patches = [ ./disable-downloads.patch ];

  prePatch = ''
    mkdir -p src/resources

    cp ${checkra1n-binary} src/resources/checkra1n-${checkra1n-platform}
    cp ${checkra1n-kpf-pongo} src/resources/checkra1n-kpf-pongo
    cp ${binpack-dmg} src/resources/binpack.dmg
    cp ${ramdisk-dmg} src/resources/ramdisk.dmg
    cp ${Pongo-bin} src/resources/Pongo.bin

    # Built with shared libraries
    substituteInPlace Makefile \
      --replace-fail "-static" "" \
      --replace-fail "\$(DEP)/lib/libimobiledevice-1.0.a" "" \
      --replace-fail "\$(DEP)/lib/libirecovery-1.0.a" "" \
      --replace-fail "\$(DEP)/lib/libusbmuxd-2.0.a" "" \
      --replace-fail "\$(DEP)/lib/libimobiledevice-glue-1.0.a" "" \
      --replace-fail "\$(DEP)/lib/libplist-2.0.a" "" \
      --replace-fail "\$(DEP)/lib/libmbedtls.a" "" \
      --replace-fail "\$(DEP)/lib/libmbedcrypto.a" "" \
      --replace-fail "\$(DEP)/lib/libmbedx509.a" "" \
      --replace-fail "\$(DEP)/lib/libreadline.a" ""

    substituteInPlace src/Makefile \
      --replace-fail "\$(DEP)/lib/libusb-1.0.a" ""
  '';

  makeFlags = [
    "PREFIX=$out"
    "CHECKRA1N_NAME=${checkra1n-platform}"
  ];

  NIX_LDFLAGS = "-limobiledevice-1.0 -lirecovery-1.0 -lmbedtls -lreadline -lusbmuxd-2.0 -lplist-2.0 -lusb-1.0 -lm -lpthread -lc";

  installPhase = ''
    mkdir -p $out/bin

    install -m755 src/palera1n $out/bin/palera1n
  '';

  meta = {
    description = "iOS 15.0-16.5.1 semi-tethered checkm8 jailbreak";
    homepage = "https://github.com/palera1n/palera1n";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.darwin ++ [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "armv7l-linux"
    ];
    maintainers = with lib.maintainers; [ phodina ];
    mainProgram = "palera1n";
    sourceProvenance = with lib.sourceTypes; [ fromSource binaryNativeCode ];
  };
})
