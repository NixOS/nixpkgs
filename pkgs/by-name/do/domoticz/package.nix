{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "2026.2-unstable-2026-07-09";

  src = fetchFromGitHub {
    owner = "domoticz";
    repo = "domoticz";
    rev = "7e12d1e5d7bf3f7d083ef31d5dd611d678f89d48"; # pinned due to removed dependency (see nixpkgs pr #539060)
    hash = "sha256-+6EIEsgGTaLEPzBa/R5EYAxnYB3+cj54LGDJwutTQGA=";
    fetchSubmodules = true;
  };

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
    # versionCheckHook # readd once we can move to a tagged release again
  ];
  doInstallCheck = true;

  meta = {
    description = "Home automation system";
    longDescription = ''
      Domoticz is a home automation system that lets you monitor and configure
      various devices like: lights, switches, various sensors/meters like
      temperature, rain, wind, UV, electra, gas, water and much more
    '';
    maintainers = with lib.maintainers; [
      edcragg
      lenny
    ];
    homepage = "https://www.domoticz.com/";
    changelog = "https://github.com/domoticz/domoticz/blob/${finalAttrs.version}/History.txt";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/domoticz.x86_64-darwin
    mainProgram = "domoticz";
  };
})
