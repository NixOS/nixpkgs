{ lib, stdenv, fetchurl, unzip, makeWrapper, libX11, zlib, libSM, libICE
, libXext , freetype, libXrender, fontconfig, libXft, libXinerama
, libXfixes, libXScrnSaver, libnotify, glib , gtk3, libappindicator-gtk3
, curl, writeShellScript, common-updater-scripts, xmlstarlet }:

let
  url = "https://app.hubstaff.com/download/8792-standard-linux-1-6-29-release/sh";
  version = "1.6.29-7f771670";
  sha256 = "sha256:09vdpsmaj26bmnbsyxp76g3677lzi8p86gz66qbdvxly6a4x1hq9";

  rpath = lib.makeLibraryPath
    [ libX11 zlib libSM libICE libXext freetype libXrender fontconfig libXft
      libXinerama stdenv.cc.cc libnotify glib gtk3 libappindicator-gtk3
      curl libXfixes libXScrnSaver ];

in

stdenv.mkDerivation {
  pname = "hubstaff";
  inherit version;

  src = fetchurl { inherit sha256 url; };

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackCmd = ''
    # MojoSetups have a ZIP file at the end. ZIP’s magic string is
    # most often PK\x03\x04. This has worked for all past updates,
    # but feel free to come up with something more reasonable.
    dataZipOffset=$(grep --max-count=1 --byte-offset --only-matching --text ''$'PK\x03\x04' $curSrc | cut -d: -f1)
    dd bs=$dataZipOffset skip=1 if=$curSrc of=data.zip 2>/dev/null
    unzip -q data.zip "data/*"
    rm data.zip
  '';

  dontBuild = true;

  installPhase = ''
    # remove files for 32-bit arch to skip building for this arch
    # but add -f flag to not fail if files were not found (new versions dont provide 32-bit arch)
    rm -rf x86 x86_64/lib64

    opt=$out/opt/hubstaff
    mkdir -p $out/bin $opt
    cp -r . $opt/

    for f in "$opt/x86_64/"*.bin.x86_64 ; do
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) $f
      wrapProgram $f --prefix LD_LIBRARY_PATH : ${rpath}
    done

    ln -s $opt/x86_64/HubstaffClient.bin.x86_64 $out/bin/HubstaffClient
    ln -s $opt/x86_64/HubstaffCLI.bin.x86_64 $out/bin/HubstaffCLI

    # Why is this needed? SEGV otherwise.
    ln -s $opt/data/resources $opt/x86_64/resources
  '';

  # to test run:
  # nix-shell maintainers/scripts/update.nix --argstr package hubstaff
  # nix-build -A pkgs.hubstaff
  passthru.updateScript = writeShellScript "hubstaff-updater" ''
    set -eu -o pipefail

    # Create a temporary file
    temp_file=$(mktemp)

    # Fetch the appcast.xml and save it to the temporary file
    curl --silent --output "$temp_file" https://app.hubstaff.com/appcast.xml

    # Extract the latest release URL for Linux using xmlstarlet
    installation_script_url=$(${xmlstarlet}/bin/xmlstarlet sel -t -v '//enclosure[@sparkle:os="linux"]/@url' "$temp_file")
    version=$(${xmlstarlet}/bin/xmlstarlet sel -t -v '//enclosure[@sparkle:os="linux"]/@sparkle:version' "$temp_file")

    sha256=$(nix-prefetch-url "$installation_script_url")

    ${common-updater-scripts}/bin/update-source-version hubstaff "$version" "sha256:$sha256" "$installation_script_url"
  '';

  meta = with lib; {
    description = "Time tracking software";
    homepage = "https://hubstaff.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ michalrus srghma ];
  };
}
