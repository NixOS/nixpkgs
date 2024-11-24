{
  lib,
  fetchurl,
  cpio,
  pbzx,
}:

{
  url,
  version,
  hash,
}:

fetchurl {
  pname = "macOS-SDK";
  inherit version url hash;

  recursiveHash = true;

  nativeBuildInputs = [
    cpio
    pbzx
  ];

  postFetch = ''
    renamed=$(mktemp -d)/sdk.xar
    mv "$downloadedFile" "$renamed"
    pbzx "$renamed" | cpio -idm

    # SDKs are inconsistent about whether MacOSX.sdk or MacOSX<version>.sdk is a symlink.
    src=Library/Developer/CommandLineTools/SDKs/MacOSX${lib.versions.majorMinor version}.sdk
    if [ ! -d $src ]; then
      src=Library/Developer/CommandLineTools/SDKs/MacOSX.sdk
    fi

    # Remove unwanted binaries, man pages, and folders from the SDK.
    rm -rf $src/usr/bin $src/usr/share $src/System/Library/Perl

    mkdir -p "$out"
    cp -rd $src/* "$out"
  '';
}
