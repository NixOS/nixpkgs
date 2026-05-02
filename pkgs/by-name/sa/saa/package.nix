{
  lib,
  stdenv,
  fetchurl,
  zlib,
  autoPatchelfHook,
}:

let
  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x86_64";
  downloadId = if stdenv.hostPlatform.isAarch64 then "1075" else "1072";
  date = "20260210";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "saa";
  version = "1.5.0";

  src = fetchurl {
    url = "https://www.supermicro.com/Bios/sw_download/${downloadId}/saa_${finalAttrs.version}_Linux_${arch}_${date}.tar.gz";
    hash =
      if stdenv.hostPlatform.isAarch64 then
        "sha256-oC18zcozDv3m6BoPtbErEO4nYgXYK9reWMWbAOA+4oc="
      else
        "sha256-1WujoJiHoerOshwu94Qq3y+HT0sFXqTVNdG9e7zjOHg=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    zlib
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/opt/saa"
    cp -r . "$out/opt/saa/"
    ln -s "$out/opt/saa/saa" "$out/bin/saa"
    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;
  dontPatchShebangs = true;
  autoPatchelfIgnoreMissingDeps = [ "*" ];

  meta = {
    description = "Supermicro SuperServer Automation Assistant for firmware and configuration management";
    homepage = "https://www.supermicro.com/en/support/resources/downloadcenter/smsdownload?category=SAA";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ youhaveme9 ];
    mainProgram = "saa";
  };
})
