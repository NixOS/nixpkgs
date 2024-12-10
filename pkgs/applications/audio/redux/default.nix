{
  lib,
  stdenv,
  fetchurl,
  libX11,
  libXext,
  alsa-lib,
  autoPatchelfHook,
  releasePath ? null,
}:

# To use the full release version (same as renoise):
# 1) Sign into https://backstage.renoise.com and download the release version to some stable location.
# 2) Override the releasePath attribute to point to the location of the newly downloaded bundle.
# Note: Renoise creates an individual build for each license which screws somewhat with the
# use of functions like requireFile as the hash will be different for every user.

stdenv.mkDerivation rec {
  pname = "redux";
  version = "1.3.2";

  src =
    if releasePath != null then
      releasePath
    else
      fetchurl {
        url = "https://files.renoise.com/demo/Renoise_Redux_${
          lib.replaceStrings [ "." ] [ "_" ] version
        }_Demo_Linux_x86_64.tar.gz";
        sha256 = "sha256-wafOeNvVIHc8pOHoNQcCwV8+OwnuevJo1EcRQKRX4YA=";
      };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libX11
    libXext
    alsa-lib
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    OUTDIR=$out/lib/vst2/RenoiseRedux.vst2
    mkdir -p $OUTDIR
    cp -r ./renoise_redux_x86_64/* $OUTDIR

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sample-based instrument, with a powerful phrase sequencer";
    homepage = "https://www.renoise.com/products/redux";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ mihnea-s ];
    platforms = [ "x86_64-linux" ];
  };
}
