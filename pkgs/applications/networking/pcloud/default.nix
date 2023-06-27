# Even though pCloud Drive is redistributed as a plug-n-play AppImage, it
# requires a little bit more love because of the way Nix launches those types
# of applications.
#
# What Nix does, simplifying a bit, is that it extracts an AppImage and starts
# it via buildFHSEnv - this is totally fine for majority of apps, but makes
# it by-design *impossible* to launch SUID wrappers [^1]; in case of pCloud,
# it's fusermount.
# (so pCloud starts, but silently fails to mount the FUSE drive.)
#
# To overcome this issue, we're manually extracting the AppImage and then treat
# it as if it was a regular, good-ol' application requiring some standard path
# fixes.
#
# ^1 https://github.com/NixOS/nixpkgs/issues/69338

{
  # Build dependencies
  appimageTools
, autoPatchelfHook
, fetchzip
, lib
, stdenv

  # Runtime dependencies;
  # A few additional ones (e.g. Node) are already shipped together with the
  # AppImage, so we don't have to duplicate them here.
, alsa-lib
, dbus-glib
, fuse
, gsettings-desktop-schemas
, gtk3
, libdbusmenu-gtk2
, libXdamage
, nss
, udev
}:

let
  pname = "pcloud";
  version = "1.12.0";
  code = "XZyc9wVZAbFzyV8ElP71D5v170CvEmVtmrB7";
  # Archive link's codes: https://www.pcloud.com/release-notes/linux.html
  src = fetchzip {
    url = "https://api.pcloud.com/getpubzip?code=${code}&filename=${pname}-${version}.zip";
    hash = "sha256-QzBlpF+qtNdSZFv3gU0mQhpVyPTWdGH3c+UHKKGfvKc=";
  };

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    src = "${src}/pcloud";
  };

in
stdenv.mkDerivation {
  inherit pname version;

  src = appimageContents;

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    dbus-glib
    fuse
    gtk3
    libdbusmenu-gtk2
    libXdamage
    nss
    udev
  ];

  installPhase = ''
    mkdir "$out"
    cp -ar . "$out/app"
    cd "$out"

    # Remove the AppImage runner, since users are not supposed to use it; the
    # actual entry point is the `pcloud` binary
    rm app/AppRun

    # Adjust directory structure, so that the `.desktop` etc. files are
    # properly detected
    mkdir bin
    mv app/usr/share .
    mv app/usr/lib .

    # Adjust the `.desktop` file
    mkdir share/applications

    substitute \
      app/pcloud.desktop \
      share/applications/pcloud.desktop \
      --replace 'Name=pcloud' 'Name=pCloud' \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    # Build the main executable
    cat > bin/pcloud <<EOF
    #! $SHELL -e

    # This is required for the file picker dialog - otherwise pcloud just
    # crashes
    export XDG_DATA_DIRS="${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS"

    exec "$out/app/pcloud"
    EOF

    chmod +x bin/pcloud
  '';

  meta = with lib; {
    description = "Secure and simple to use cloud storage for your files; pCloud Drive, Electron Edition";
    homepage = "https://www.pcloud.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ patryk27 ];
    platforms = [ "x86_64-linux" ];
  };
}
