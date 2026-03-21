{
  lib,
  stdenv,
  fetchurl,
}:

# libhdhomerun requires UDP port 65001 to be open in order to detect and communicate with tuners.
# If your firewall is enabled, make sure to have something like:
#   networking.firewall.allowedUDPPorts = [ 65001 ];

stdenv.mkDerivation (finalAttrs: {
  pname = "libhdhomerun";
  version = "20260313";

  src = fetchurl {
    url = "https://download.silicondust.com/hdhomerun/libhdhomerun_${finalAttrs.version}.tgz";
    hash = "sha256-eS1DuYvcFG+ohy+CBfT4/rHB1VV+PHft2mtrHt6bnbA=";
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

  meta = {
    description = "Implements the libhdhomerun protocol for use with Silicondust HDHomeRun TV tuners";
    mainProgram = "hdhomerun_config";
    homepage = "https://www.silicondust.com/support/linux";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ sielicki ];
    platforms = lib.platforms.unix;
  };
})
