{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
  cmake,
  python3,
  openssl,
  pkg-config,
  mosquitto,
  lua5_3,
  sqlite,
  jsoncpp,
  zlib,
  boost,
  curl,
  git,
  libusb-compat-0_1,
  cereal,
  minizip,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "domoticz";
  version = "2024.7";

  src = fetchFromGitHub {
    owner = "domoticz";
    repo = "domoticz";
    tag = finalAttrs.version;
    hash = "sha256-D8U1kK3m1zT83YvZ42hGSU9PzBfS1VGr2mxUYbM2vNQ=";
  };

  patches = [
    # Boost 1.87 compatibility, remove once upgraded to 2025.1
    (fetchpatch {
      url = "https://github.com/domoticz/domoticz/commit/5d0db89bbd120ed5dc05b4ff8c136f14a42f0cd3.patch";
      hash = "sha256-FPe83yJKJEgnY3kABy9CTRe1CBh42dPG1ZWCUE5PO8E=";
    })
  ];

  buildInputs = [
    openssl
    python3
    mosquitto
    lua5_3
    sqlite
    jsoncpp
    boost
    zlib
    curl
    git
    libusb-compat-0_1
    cereal
    minizip
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  cmakeFlags = [
    "-DUSE_BUILTIN_MQTT=false"
    "-DUSE_BUILTIN_LUA=false"
    "-DUSE_BUILTIN_SQLITE=false"
    "-DUSE_BUILTIN_JSONCPP=false"
    "-DUSE_BUILTIN_ZLIB=false"
    "-DUSE_OPENSSL_STATIC=false"
    "-DUSE_STATIC_BOOST=false"
    "-DUSE_BUILTIN_MINIZIP=false"
  ];

  installPhase = ''
    mkdir -p $out/share/domoticz
    cp -r $src/www $out/share/domoticz/
    cp -r $src/Config $out/share/domoticz
    cp -r $src/scripts $out/share/domoticz
    cp -r $src/plugins $out/share/domoticz

    mkdir -p $out/bin
    cp domoticz $out/bin
    wrapProgram $out/bin/domoticz --set LD_LIBRARY_PATH ${python3}/lib;
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Home automation system";
    longDescription = ''
      Domoticz is a home automation system that lets you monitor and configure
      various devices like: lights, switches, various sensors/meters like
      temperature, rain, wind, UV, electra, gas, water and much more
    '';
    maintainers = with lib.maintainers; [ edcragg ];
    homepage = "https://www.domoticz.com/";
    changelog = "https://github.com/domoticz/domoticz/blob/${finalAttrs.version}/History.txt";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/domoticz.x86_64-darwin
    mainProgram = "domoticz";
  };
})
