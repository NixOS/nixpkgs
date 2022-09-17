{ autoPatchelfHook
, electron
, fetchurl
, lib
, makeWrapper
, squashfsTools
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "authy";
  # curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/authy?channel=stable' | jq '.download_url,.version'
  version = "2.2.1";
  rev = "11";

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/H8ZpNgIoPyvmkgxOWw5MSzsXK1wRZiHn_${rev}.snap";
    sha256 = "sha256-/a0pMXVd7mEp7oaN2mBIJv5uOv1zQ3gvfgiz1XL9ZmM=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper squashfsTools ];

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src"
    cd squashfs-root
    if ! grep -q '${version}' meta/snap.yaml; then
      echo "Package version differs from version found in snap metadata:"
      grep 'version: ' meta/snap.yaml
      echo "While the nix package specifies: ${version}."
      echo "You probably chose the wrong revision or forgot to update the nix version."
      exit 1
    fi
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications $out/share/pixmaps/apps

    # Copy only what is needed
    cp -r resources* $out/
    cp -r locales* $out/
    cp meta/gui/authy.desktop $out/share/applications/
    cp meta/gui/icon.png $out/share/pixmaps/authy.png

    # Replace icon name in Desktop file
    sed -i 's|''${SNAP}/meta/gui/icon.png|authy|g' "$out/share/applications/authy.desktop"

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/resources/app.asar
  '';

  meta = with lib; {
    homepage = "https://www.authy.com";
    description = "Twilio Authy two factor authentication desktop application";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ iammrinal0 ];
    platforms = [ "x86_64-linux" ];
  };
}
