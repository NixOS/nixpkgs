{
  lib,
  stdenv,
  fetchurl,
  git,
  xz,
  xxd,
  libimobiledevice,
  libimobiledevice-glue,
  libirecovery,
  libplist,
  libusbmuxd,
  libusb1,
  mbedtls,
  readline,
  fetchFromGitHub,
}:

let
  checkra1nVersion = "0.1337.3";
  checkra1nNames = {
    x86_64-linux = "linux-x86_64";
    aarch64-linux = "linux-arm64";
    i686-linux = "linux-x86";
    armv7l-linux = "linux-armel";
  };
  checkra1nName = checkra1nNames.${stdenv.hostPlatform.system};
  checkra1n = fetchurl {
    url = "https://assets.checkra.in/downloads/preview/${checkra1nVersion}/checkra1n-${checkra1nName}";
    sha256 = "sha256-UxVNh1lM9nxWZZ8kVH8bW7Uzb4TqWMLULyWnst+BqWQ=";
  };
  kpf = fetchurl {
    url = "https://cdn.nickchan.lol/palera1n/artifacts/kpf/iOS15/checkra1n-kpf-pongo";
    sha256 = "sha256-EWKaBuDXYzED5AcdJglhnenVJTQNvACMps8K10l7wRg=";
  };
  ramdisk = fetchurl {
    url = "https://cdn.nickchan.lol/palera1n/c-rewrite/deps/ramdisk.dmg";
    sha256 = "sha256-4ubbTpLGUk0KqRXBJP6WPW+mfefC+jO7jbnk7kVGa2w=";
  };
  binpack = fetchurl {
    url = "https://cdn.nickchan.lol/palera1n/c-rewrite/deps/binpack.dmg";
    sha256 = "sha256-JmxGdlE5OOXHOLpOa/xsyUyuxXOSyWDM22cmA+uk1HY=";
  };
  pongo = fetchurl {
    url = "https://cdn.nickchan.lol/palera1n/artifacts/kpf/iOS15/Pongo.bin";
    sha256 = "sha256-HE0LxY+MuWrH/xrLXl03E9PC7aLLexZNvPOEB9mR/qE=";
  };
  makeFlagsList = [
    "CHECKRA1N_NAME=${checkra1nName}"
  ];
in
stdenv.mkDerivation {
  pname = "palera1n";
  version = "2.2.1+unstable=2026-01-17";
  src = fetchFromGitHub {
    owner = "palera1n";
    repo = "palera1n";
    rev = "62e03acf81f7aaa5a7b3d4a25d08d0bef3731a05";
    sha256 = "sha256-gcU94tZR6pMp37tB5FEK3KVEP3fYjcMQSEPaE8We7Hc=";
  };

  nativeBuildInputs = [
    git
    xz
    xxd
  ];
  buildInputs = [
    libimobiledevice
    libimobiledevice-glue
    libirecovery
    libplist
    libusbmuxd
    libusb1
    mbedtls
    readline
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'CFLAGS += -isystem $(DEP)/include -I$(SRC)/include -I$(SRC) -D_XOPEN_SOURCE=500' \
                'CFLAGS += -I$(SRC)/include -I$(SRC) -D_XOPEN_SOURCE=500' \
      --replace 'LIBS += $(DEP)/lib/libimobiledevice-1.0.a $(DEP)/lib/libirecovery-1.0.a $(DEP)/lib/libusbmuxd-2.0.a' \
                'LIBS += -limobiledevice-1.0 -lirecovery-1.0 -lusbmuxd-2.0' \
      --replace 'LIBS += $(DEP)/lib/libimobiledevice-glue-1.0.a $(DEP)/lib/libplist-2.0.a -pthread -lm' \
                'LIBS += -limobiledevice-glue-1.0 -lplist-2.0 -pthread -lm' \
      --replace 'LIBS += $(DEP)/lib/libmbedtls.a $(DEP)/lib/libmbedcrypto.a $(DEP)/lib/libmbedx509.a $(DEP)/lib/libreadline.a' \
                'LIBS += -lmbedtls -lmbedcrypto -lmbedx509 -lreadline' \
      --replace 'LDFLAGS += -static -no-pie' 'LDFLAGS +='
    substituteInPlace src/Makefile \
      --replace 'LIBS += $(DEP)/lib/libusb-1.0.a' 'LIBS += -lusb-1.0'
  '';

  preBuild = ''
    mkdir -p src/resources
    cp ${checkra1n} src/resources/checkra1n-${checkra1nName}
    cp ${checkra1n} src/resources/checkra1n-macos
    cp ${kpf} src/resources/checkra1n-kpf-pongo
    cp ${ramdisk} src/resources/ramdisk.dmg
    cp ${binpack} src/resources/binpack.dmg
    cp ${pongo} src/resources/Pongo.bin
    chmod 755 src/resources/checkra1n-${checkra1nName}
    chmod 755 src/resources/checkra1n-macos
  '';

  makeFlags = makeFlagsList;

  buildPhase = ''
    runHook preBuild
    make ${lib.escapeShellArgs makeFlagsList} -o download-deps
    runHook postBuild
  '';

  installPhase = ''
    install -Dm755 src/palera1n $out/bin/palera1n
  '';

  meta = {
    description = "Jailbreak for A8 through A11, T2 devices, on iOS/iPadOS/tvOS 15.0+";
    homepage = "https://palera.in";
    license = lib.licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
      "armv7l-linux"
    ];
    maintainers = [ "mugiwarix" ];
  };
}
