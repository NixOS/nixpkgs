{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  pcsclite,
  ...
}:
stdenv.mkDerivation rec {
  pname = "rtpkcs11ecp";
  version = "2.18.4.0";

  src = fetchurl {
    url = "https://download.rutoken.ru/Rutoken/PKCS11Lib/${version}/Linux/x64/librtpkcs11ecp_${version}-1_amd64.deb";
    hash = "sha256-3alkDqC/EqUYsF5/paody64W3SvkVNVRCetYztclq98=";
  };

  dontBuild = true;
  dontConfigure = true;

  buildInputs = [ pcsclite ];
  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  unpackCmd = "dpkg -X $curSrc source";
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib"
    install -D opt/aktivco/rutokenecp/amd64/librtpkcs11ecp.so "$out/lib/librtpkcs11ecp.so"

    runHook postInstall
  '';
  fixupPhase = ''
    runHook preFixup

    autoPatchelf "$out"

    runHook postFixup
  '';

  meta = {
    description = "Rutoken PKCS#11 Library";
    homepage = "https://www.rutoken.ru/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.maxmosk ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
