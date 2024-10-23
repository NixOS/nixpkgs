{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "libloragw-sx1302";
  version = "2.1.0r7";

  src = fetchFromGitHub {
    owner = "brocaar";
    repo = "sx1302_hal";
    rev = "c3d99009556fdfe273c3a53306082ef181333c7a";
    hash = "sha256-Ue3C7XbaCv/d0NIMclPSE+qcQpxw70DVhXlnpFACzhY=";
  };

  makeFlags = [
    "-e"
    "-C"
    "libloragw"
  ];

  preBuild = ''
    make -C libtools
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,include/libloragw-sx1302}
    cp libloragw/libloragw.a $out/lib/libloragw-sx1302.a
    cp libloragw/inc/* $out/include/libloragw-sx1302
    cp libtools/*.a $out/lib/
    cp libtools/inc/* $out/include/

    runHook postInstall
  '';

  meta = {
    description = "SX1302 Hardware Abstraction Layer and Tools (packet forwarder...)";
    license = [
      lib.licenses.bsd3
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.stv0g ];
    platforms = [ "aarch64-linux" ];
  };
}
