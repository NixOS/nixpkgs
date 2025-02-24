{
  lib,
  stdenv,
  fetchurl,
  writeScript,
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
  version = "1.3.5";

  src =
    if releasePath != null then
      releasePath
    else
      fetchurl {
        urls = [
          "https://files.renoise.com/demo/Renoise_Redux_${
            lib.replaceStrings [ "." ] [ "_" ] version
          }_Demo_Linux_x86_64.tar.gz"
          "https://files.renoise.com/demo/archive/Renoise_Redux_${
            lib.replaceStrings [ "." ] [ "_" ] version
          }_Demo_Linux_x86_64.tar.gz"
        ];
        sha256 = "sha256-eznsdLzgdJ7MyWe5WAEg1MHId5VlfyanoZ6+I9nI/0I=";
      };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libX11
    libXext
    alsa-lib
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    runHook preInstall

    OUTDIR=$out/lib/vst2/RenoiseRedux.vst2
    mkdir -p $OUTDIR
    cp -r ./renoise_redux_x86_64/* $OUTDIR

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update-redux" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -I nixpkgs=./. -i bash -p curl htmlq common-updater-scripts
    set -euo pipefail

    new_version="$(
      curl 'https://files.renoise.com/demo/' \
        | htmlq a --text \
        | grep -E '^Renoise_Redux_([0-9]+_?)+_Demo_Linux_x86_64\.tar\.gz$' \
        | grep -Eo '[0-9]+(_[0-9]+)*' \
        | head -n1 \
        | tr _ .
    )"
    update-source-version redux "$new_version" --system="x86_64-linux"
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
