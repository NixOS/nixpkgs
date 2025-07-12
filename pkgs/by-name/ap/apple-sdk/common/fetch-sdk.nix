{
  lib,
  fetchurl,
  cpio,
  pbzx,
}:

{
  urls,
  version,
  hash,

  # Include man pages
  includeMan ? lib.toInt (lib.versions.major version) >= 15,
}:

fetchurl {
  pname = "macOS-SDK";
  inherit version urls hash;

  recursiveHash = true;

  nativeBuildInputs = [
    cpio
    pbzx
  ];

  postFetch = ''
    renamed=$(mktemp -d)/sdk.xar
    mv "$downloadedFile" "$renamed"
    pbzx "$renamed" | cpio -idm

    src=Library/Developer/CommandLineTools/SDKs/MacOSX${lib.versions.majorMinor version}.sdk

    # Remove unwanted binaries and folders from the SDK.
    rm -rf $src/usr/bin $src/System/Library/Perl
    if [[ -z "${toString includeMan}" ]]; then
      rm -rf $src/usr/share
    fi

    mkdir -p "$out"
    cp -rd $src/* "$out"
  '';

  passthru = {
    inherit includeMan;
  };
}
