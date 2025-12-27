{
  stdenv,
  lib,
  fetchFromGitHub,
  openssl,
}:
let
  # https://github.com/philippe44/cross-compiling/blob/master/README.md
  #
  # The author has their own way of managing cross-compilation.
  # We hook into their `make` process with the correct "host" and "platform" to
  # build the appropriate binaries.
  #
  # Supported targets are specified in:
  #   https://github.com/philippe44/AirConnect/blob/master/build.sh
  host =
    if stdenv.isLinux then
      "linux"
    else if stdenv.isDarwin then
      "macos"
    else
      throw "Unsupported operating system.";
  platform =
    if stdenv.isLinux then
      stdenv.targetPlatform.linuxArch
    else if stdenv.isDarwin then
      stdenv.targetPlatform.darwinArch
    else
      throw "Unsupported operating system.";
in
stdenv.mkDerivation rec {
  pname = "airconnect";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "philippe44";
    repo = "AirConnect";
    rev = version;
    hash = "sha256-aF24SZvBH74AjDG/0ptmEtjLlFvKax3PMDQsrlhS0KE=";
    fetchSubmodules = true; # many dependencies pulled in through Git, most written by the same author
  };

  buildInputs = [
    openssl
  ];

  env = {
    # required by the `make` targets
    PLATFORM = platform;
    HOST = host;
    # explicitly link in OpenSSL, as it's required but assumed
    NIX_LDFLAGS = "-lcrypto -lssl";
  };

  buildPhase = ''
    runHook preBuild
    make -C aircast directory ../bin/aircast-${host}-${platform}
    make -C airupnp directory ../bin/airupnp-${host}-${platform}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D bin/aircast-${host}-${platform} $out/bin/aircast
    install -D bin/airupnp-${host}-${platform} $out/bin/airupnp
    runHook postInstall
  '';

  meta = {
    description = "Send audio to UPnP/Sonos/Chromecast players using AirPlay";
    homepage = "https://github.com/philippe44/AirConnect";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SamirTalwar ];
    platforms = lib.platforms.linux;
    # This should work on Darwin, but does not link correctly against OpenSSL
    # Details: https://github.com/philippe44/AirConnect/discussions/511
    badPlatforms = lib.platforms.darwin;
    changelog = "https://github.com/philippe44/AirConnect/blob/master/CHANGELOG";
  };
}
