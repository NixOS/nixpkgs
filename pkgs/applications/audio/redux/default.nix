{ lib
, stdenv
, fetchurl
, libX11
, alsa-lib
, autoPatchelfHook
, releasePath ? null
}:

# To use the full release version (same as renoise):
# 1) Sign into https://backstage.renoise.com and download the release version to some stable location.
# 2) Override the releasePath attribute to point to the location of the newly downloaded bundle.
# Note: Renoise creates an individual build for each license which screws somewhat with the
# use of functions like requireFile as the hash will be different for every user.

let
  version = "1.2.2";
in

stdenv.mkDerivation rec {
  pname = "redux";
  inherit version;

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      if releasePath != null then releasePath else
      fetchurl {
        url = "https://files.renoise.com/demo/Renoise_Redux_${lib.replaceStrings ["."] ["_"] version}_Demo_Linux.tar.gz";
        sha256 = "0zbwsg7nh9x3q29jv2kpqb3vwi0ksdwybhb4m2qr95rxrpx1kxhm";
      }
    else throw "Platform is not supported. Use instalation native to your platform https://www.renoise.com/";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [ libX11 alsa-lib stdenv.cc.cc.lib ];

  installPhase = ''
    OUTDIR=$out/lib/vst2/RenoiseRedux.vst2
    mkdir -p $OUTDIR
    cp -r ./renoise_redux_x86_64/* $OUTDIR
  '';

  meta = with lib; {
    description = "Sample-based instrument, with a powerful phrase sequencer";
    homepage = "https://www.renoise.com/products/redux";
    license = licenses.unfree;
    maintainers = with maintainers; [ mihnea-s ];
    platforms = [ "x86_64-linux" ];
  };
}
