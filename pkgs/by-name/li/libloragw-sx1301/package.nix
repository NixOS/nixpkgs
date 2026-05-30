{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libloragw-sx1301";
  version = "5.0.1r4";

  src = fetchFromGitHub {
    owner = "brocaar";
    repo = "lora_gateway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YxnFWJhH5iUR+6zA0Pf7a+VxFwYkw84CeoQmd01efqU=";
  };

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  makeFlags = [
    "-e"
    "-C"
    "libloragw"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,include/libloragw-sx1301}
    cp libloragw/libloragw.a $out/lib/libloragw-sx1301.a
    cp libloragw/inc/* $out/include/libloragw-sx1301

    runHook postInstall
  '';

  meta = {
    description = "Driver/HAL to build a gateway using a concentrator board based on Semtech SX1301 multi-channel modem and SX1257/SX1255 RF transceivers";
    license = [
      lib.licenses.bsd3
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.stv0g ];
    platforms = lib.platforms.linux;
  };
})
