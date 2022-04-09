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
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "pinegrow";
  version = "6.5";

  src = fetchurl {
    url = "https://download.pinegrow.com/PinegrowLinux64.${version}.zip";
    sha256 = "1l7cf5jgidpykaf68mzf92kywl1vxwl3fg43ibgr2rg4cnl1g82b";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = [
    udev
    nwjs
    gcc-unwrapped
    gsettings-desktop-schemas
    gtk3
  ];

  dontWrapGApps = true;
  makeWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ gcc-unwrapped.lib gtk3 udev ]}"
    "--prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}"
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
    unzip -q $src -d $out/opt/pinegrow
    substituteInPlace $out/opt/pinegrow/Pinegrow.desktop \
      --replace 'Exec=sh -c "$(dirname %k)/PinegrowLibrary"' 'Exec=sh -c "$out/bin/Pinegrow"'
    mv $out/opt/pinegrow/Pinegrow.desktop $out/share/applications/Pinegrow.desktop
    ln -s $out/opt/pinegrow/PinegrowLibrary $out/bin/Pinegrow

    runHook postInstall
  '';

  # GSETTINGS_SCHEMAS_PATH is not set in installPhase
  preFixup = ''
    wrapProgram $out/bin/Pinegrow \
      ''${makeWrapperArgs[@]} \
      ''${gappsWrapperArgs[@]}
  '';

  meta = with lib; {
    homepage = "https://pinegrow.com";
    description = "UI Web Editor";
    platforms = platforms.linux;
    license = with licenses; [ unfreeRedistributable ];
    maintainers = with maintainers; [ gador ];
  };
}
