{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libloragw-sx1302";
  version = "2.1.0r9";

  src = fetchFromGitHub {
    owner = "brocaar";
    repo = "sx1302_hal";
    rev = "refs/tags/V${finalAttrs.version}";
    hash = "sha256-NYu54UpMn2OZfGihBH9Kbp2kUcEy0epH1Tt5I3r6jTs=";
  };

  passthru.updateScript = gitUpdater { rev-prefix = "V"; };

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
    platforms = lib.platforms.linux;
  };
})
