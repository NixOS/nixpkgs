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
, pinegrowVersion ? "7"
}:

let
  # major version upgrade requires a new license. So keep version 6 around.
  versions = {
    "6" = {
      version = "6.8";
      src = fetchurl {
        url = "https://download.pinegrow.com/PinegrowLinux64.${versions."6".version}.zip";
        sha256 = "sha256-gqRmu0VR8Aj57UwYYLKICd4FnYZMhM6pTTSGIY5MLMk=";
      };
    };
    "7" = {
      version = "7.03";
      src = fetchurl {
        url = "https://download.pinegrow.com/PinegrowLinux64.${versions."7".version}.zip";
        sha256 = "sha256-MdaJBmOPr1+J235IZPd3EBzbDTiORginyVKsjSkKbpE=";
      };
    };
  };
in

stdenv.mkDerivation rec {
  pname = "pinegrow";
  # deactivate auto update, because an old 6.21 version is getting mixed up
  # see e.g. https://github.com/NixOS/nixpkgs/pull/184460
  version = versions.${pinegrowVersion}.version; # nixpkgs-update: no auto update

  src = versions.${pinegrowVersion}.src;

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
      --replace 'Exec=sh -c "$(dirname %k)/PinegrowLibrary"' 'Exec=sh -c "$out/bin/pinegrow"'
    mv $out/opt/pinegrow/Pinegrow.desktop $out/share/applications/pinegrow.desktop
    ln -s $out/opt/pinegrow/PinegrowLibrary $out/bin/pinegrow

    runHook postInstall
  '';

  # GSETTINGS_SCHEMAS_PATH is not set in installPhase
  preFixup = ''
    wrapProgram $out/bin/pinegrow \
      ''${makeWrapperArgs[@]} \
      ''${gappsWrapperArgs[@]}
  '';

  meta = with lib; {
    homepage = "https://pinegrow.com";
    description = "UI Web Editor";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = with licenses; [ unfreeRedistributable ];
    maintainers = with maintainers; [ gador ];
  };
}
