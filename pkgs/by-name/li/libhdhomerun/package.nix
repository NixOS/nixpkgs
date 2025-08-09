{
  lib,
  stdenv,
  fetchurl,
}:

# libhdhomerun requires UDP port 65001 to be open in order to detect and communicate with tuners.
# If your firewall is enabled, make sure to have something like:
#   networking.firewall.allowedUDPPorts = [ 65001 ];

stdenv.mkDerivation rec {
  pname = "libhdhomerun";
  version = "20250506";

  src = fetchurl {
    url = "https://download.silicondust.com/hdhomerun/libhdhomerun_${version}.tgz";
    hash = "sha256-h5sbxHbJuT537igKhPwRV+fMR9Q+2cg5jYiorF81wDQ=";
  };

  patches = [
    ./nixos-darwin-no-fat-dylib.patch
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,include/hdhomerun}
    install -Dm444 libhdhomerun${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib
    install -Dm555 hdhomerun_config $out/bin
    cp *.h $out/include/hdhomerun

    runHook postInstall
  '';

  meta = with lib; {
    description = "Implements the libhdhomerun protocol for use with Silicondust HDHomeRun TV tuners";
    mainProgram = "hdhomerun_config";
    homepage = "https://www.silicondust.com/support/linux";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ sielicki ];
    platforms = platforms.unix;
  };
}
