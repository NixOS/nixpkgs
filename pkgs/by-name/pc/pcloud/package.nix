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
  appimageTools,
  autoPatchelfHook,
  patchelfUnstable,
  fetchzip,
  lib,
  stdenv,

  # Runtime dependencies;
  # A few additional ones (e.g. Node) are already shipped together with the
  # AppImage, so we don't have to duplicate them here.
  alsa-lib,
  dbus-glib,
  fuse,
  gsettings-desktop-schemas,
  gtk3,
  libdbusmenu-gtk2,
  libgbm,
  libxdamage,
  nss,
  udev,
}:

let
  pname = "pcloud";
  version = "2.0.3";
  code = "XZ8opl5ZaaYsnBeCX3fLU3v8ngqAv8VMqq7k";

  # Archive link's codes: https://www.pcloud.com/release-notes/linux.html
  src = fetchzip {
    url = "https://api.pcloud.com/getpubzip?code=${code}&filename=pcloud-${version}.zip";
    hash = "sha256-Few8BsMUwL5qfdtFyezoWifZcZufAhUthxQXEQwm52w=";
  };

in
stdenv.mkDerivation {
  inherit pname version;

  src = appimageTools.extractType2 {
    inherit pname version;

    src = "${src}/pCloud.AppImage";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    patchelfUnstable
  ];

  buildInputs = [
    alsa-lib
    dbus-glib
    fuse
    gtk3
    libdbusmenu-gtk2
    libgbm
    libxdamage
    nss
    udev
  ];

  installPhase = ''
    mkdir "$out"
    cp -ar . "$out/app"
    cd "$out"

    # Remove AppImage runner, users are not supposed to use it - `pcloud` binary
    # itself is the correct entrypoint
    rm app/AppRun

    # Remove random stuff that causes patchelf to complain about missing deps
    # that are not, in fact, missing deps, because those files don't get
    # executed in the first place
    rm app/resources/app.asar.unpacked/node_modules/koffi/build/koffi/musl_x64/koffi.node
    rm app/resources/app.asar.unpacked/node_modules/koffi/build/koffi/openbsd_x64/koffi.node

    # Adjust the directory structure, so that `.desktop` etc. files are detected
    mkdir bin
    mv app/usr/share .
    mv app/usr/lib .

    # Adjust the `.desktop` file
    mkdir share/applications

    substitute \
      app/pcloud.desktop \
      share/applications/pcloud.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    # Adjust the icons
    ln -snf $out/share/icons/hicolor/512x512/apps/pcloud.png app/.DirIcon
    ln -snf $out/share/icons/hicolor/512x512/apps/pcloud.png app/pcloud.png

    # Build the entrypoint
    cat > bin/pcloud <<EOF
    #! $SHELL -e

    # Required for the file picker dialog - otherwise pcloud crashes
    export XDG_DATA_DIRS="${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS"

    exec "$out/app/pcloud"
    EOF

    chmod +x bin/pcloud
  '';

  meta = {
    description = "Secure and simple to use cloud storage for your files; pCloud Drive, Electron Edition";
    homepage = "https://www.pcloud.com/";
    changelog = "https://www.pcloud.com/release-notes/linux.html";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ patryk27 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "pcloud";
  };
}
