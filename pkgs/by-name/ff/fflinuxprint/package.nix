{
  autoPatchelfHook,
  cups,
  dpkg,
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fflinuxprint";
  version = "1.1.4-3";

  src = fetchurl {
    url = "https://support-fb.fujifilm.com/driver_downloads/fflinuxprint_${finalAttrs.version}_amd64.deb";
    hash = "sha256-oi6p4e9Uigz0TbEcmloDhv3qU98Ou1qqdorGY3942uM=";
    curlOpts = "--user-agent Mozilla/5.0"; # HTTP 410 otherwise
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    cups
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/cups/model
    mv usr/lib $out
    mv usr/share/ppd/fujifilm/* $out/share/cups/model

    runHook postInstall
  '';

  meta = {
    description = "FujiFILM Linux Printer Driver";
    homepage = "https://support-fb.fujifilm.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ jaduff ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
