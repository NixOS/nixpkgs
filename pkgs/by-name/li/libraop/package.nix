{
  lib,
  fetchFromGitHub,
  openssl,
  stdenv,
}:

let
  host =
    if stdenv.hostPlatform.isLinux then
      "linux"
    else if stdenv.hostPlatform.isDarwin then
      "macos"
    else
      throw "libraop does not support this platform, yet";
in
stdenv.mkDerivation {
  pname = "libraop";
  version = "0-unstable-2026-02-09";

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "libraop";
    # we try to closely match the commit used in the last music-assistant release from
    # https://github.com/music-assistant/server/tree/stable/music_assistant/providers/airplay/bin
    rev = "f49284282ea4ea740d07fabc230b4182f8c69a74";
    fetchSubmodules = true;
    hash = "sha256-m1ll5vRZx4d/5IWCG24yY/SWEIIz2k/iU84vQKHlCdo=";
  };

  patches = [
    # https://github.com/philippe44/libraop/pull/48
    ./link-libssl.diff
  ];

  postPatch = ''
    # the most security critical part we build ourself
    rm -r libopenssl/

    # do not confuse the prebuilt binaries with the ones we build
    rm bin/*

    # easen debugging and we strip ourselves, too
    substituteInPlace Makefile \
      --replace-fail "LDFLAGS += -s" "LDFLAGS +="
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # on darwin the direct dlopen to system libcrypto crashes with
    # WARNING: /nix/store/.../bin/cliraop is loading libcrypto in an unsafe way
    # Abort trap: 6
    substituteInPlace crosstools/src/cross_ssl.c \
      --replace-fail '"libcrypto.dylib"' '"${lib.getLib openssl}/lib/libcrypto.dylib"' \
      --replace-fail '"libssl.dylib"' '"${lib.getLib openssl}/lib/libssl.dylib"'
  '';

  buildInputs = [
    openssl
  ];

  makeFlags = [
    "HOST=${host}"
    "PLATFORM=${stdenv.hostPlatform.uname.processor}"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/cliraop-${host}-${stdenv.hostPlatform.uname.processor} $out/bin/cliraop
  '';

  meta = {
    description = "RAOP player and library (AirPlay)";
    homepage = "https://github.com/music-assistant/libraop";
    # https://github.com/philippe44/libraop/issues/36
    license = with lib.licenses; [
      gpl2Only
      mit
    ];
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "cliraop";
    platforms = with lib.platforms; linux ++ darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
