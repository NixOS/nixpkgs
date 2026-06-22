{
  lib,
  pkgs,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
}:
# From https://aur.archlinux.org/cgit/aur.git/tree/?h=duo-desktop
stdenv.mkDerivation rec {
  pname = "duo-desktop";
  # Version number is available at https://duo.com/docs/duo-desktop-notes#duo-desktop-for-linux
  version = "4.5.0";

  # Only latest package is available
  src =
    let
      srcs = {
        x86_64-linux = fetchurl {
          url = "https://desktop.pkg.duosecurity.com/${pname}-latest.x86_64.rpm";
          sha256 = "sha256-tT4H70ssW/igOXd/6hXnKDGPdU/Ft4sDuVpCzLw7kHw=";
        };
        aarch64-linux = fetchurl {
          url = "https://desktop.pkg.duosecurity.com/${pname}-latest.aarch64.rpm";
          sha256 = "sha256-GfsNxmo3zHUBzTkZzNjcsVMWB+YTr4KgFMRBWryGD3o=";
        };
      };
    in
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  strictDeps = true;
  nativeBuildInputs = with pkgs; [
    rpm
    cpio
    autoPatchelfHook
    makeWrapper
  ];

  unpackPhase = ''
    rpm2cpio $src | cpio -idmv
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -dpr --no-preserve=ownership opt $out

    # systemd unit is at the wrong location
    cp -dpr --no-preserve=ownership usr/lib $out
    # package's /url/lib contain a build result folder (.build-id) with symlinks to the binary.
    # After moving the lib folder, the symlinks is broken, so we have to remove it.
    rm -rf $out/lib/.build-id

    makeWrapper $out/opt/duo/duo-desktop/duo-desktop $out/bin/duo-desktop \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          with pkgs;
          [
            openssl
            icu
          ]
        )
      }
  '';

  __structuredAttrs = true;

  meta = with lib; {
    description = "Duo Desktop gives Duo customers more control over which computers can access corporate applications based on the trust (with Trusted Endpoints) and security posture of the device (with Device Health).";
    homepage = "https://duo.com/docs/duo-desktop";
    license = licenses.unfree;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [ n0rad ];
  };
}
