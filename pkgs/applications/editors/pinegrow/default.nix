{ stdenv
, lib
, fetchurl
, unzip
, udev
, nwjs
, gcc-unwrapped
, autoPatchelfHook
, gsettings-desktop-schemas
, gtk3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "pinegrow";
  version = "6.3";

  src = fetchurl {
    url = "https://download.pinegrow.com/PinegrowLinux64.${version}.zip";
    sha256 = "0wldj633p67da077nfc67gr9xhq580rkfd0r3904sjq7x01r0kaz";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    udev
    nwjs
    gcc-unwrapped
    gsettings-desktop-schemas
    gtk3
  ];

  sourceRoot = ".";

  dontUnpack = true;

  # Extract and copy executable in $out/bin
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/applications $out/bin $out/opt/bin
    # we can't unzip it in $out/lib, because nw.js will start with
    # an empty screen. Therefore it will be unzipped in a non-typical
    # folder and symlinked.
    unzip $src -d $out/opt/pinegrow
    substituteInPlace $out/opt/pinegrow/Pinegrow.desktop \
      --replace 'Exec=sh -c "$(dirname %k)/PinegrowLibrary"' 'Exec=sh -c "$out/bin/Pinegrow"'
    mv $out/opt/pinegrow/Pinegrow.desktop $out/share/applications/Pinegrow.desktop
    ln -s $out/opt/pinegrow/PinegrowLibrary $out/bin/Pinegrow

    runHook postInstall
  '';

  preFixup = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    wrapGApp "$out/opt/pinegrow/PinegrowLibrary" --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]}
  '';

  meta = with lib; {
    homepage = "https://pinegrow.com";
    description = "UI Web Editor";
    platforms = platforms.linux;
    license = with licenses; [ unfreeRedistributable ];
    maintainers = with maintainers; [ gador ];
  };
}
