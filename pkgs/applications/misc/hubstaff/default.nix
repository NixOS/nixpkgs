{ lib, stdenv, fetchurl, unzip, makeWrapper, libX11, zlib, libSM, libICE
, libXext , freetype, libXrender, fontconfig, libXft, libXinerama
, libXfixes, libXScrnSaver, libnotify, glib , gtk3, libappindicator-gtk3
, curl, writeShellScript, common-updater-scripts }:

let
  url = "https://hubstaff-production.s3.amazonaws.com/downloads/HubstaffClient/Builds/Release/1.6.5-31be26f1/Hubstaff-1.6.5-31be26f1.sh";
  version = "1.6.5-31be26f1";
  sha256 = "1z1binnqppyxavmjg0l1cvy64ylzy2v454sws2x1am2qhhbnycjm";

  rpath = lib.makeLibraryPath
    [ libX11 zlib libSM libICE libXext freetype libXrender fontconfig libXft
      libXinerama stdenv.cc.cc.lib libnotify glib gtk3 libappindicator-gtk3
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
    # TODO: handle 32-bit arch?
    rm -r x86
    rm -r x86_64/lib64

    opt=$out/opt/hubstaff
    mkdir -p $out/bin $opt
    cp -r . $opt/

    for f in "$opt/x86_64/"*.bin.x86_64 ; do
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) $f
      wrapProgram $f --prefix LD_LIBRARY_PATH : ${rpath}
    done

    ln -s $opt/x86_64/HubstaffClient.bin.x86_64 $out/bin/HubstaffClient

    # Why is this needed? SEGV otherwise.
    ln -s $opt/data/resources $opt/x86_64/resources
  '';

  updateScript = writeShellScript "hubstaff-updater" ''
    set -eu -o pipefail

    installation_script_url=$(curl --fail --head --location --silent --output /dev/null --write-out %{url_effective} https://app.hubstaff.com/download/linux)

    version=$(echo "$installation_script_url" | sed -r 's/^https:\/\/hubstaff\-production\.s3\.amazonaws\.com\/downloads\/HubstaffClient\/Builds\/Release\/([^\/]+)\/Hubstaff.+$/\1/')

    sha256=$(nix-prefetch-url "$installation_script_url")

    ${common-updater-scripts}/bin/update-source-version hubstaff "$version" "$sha256" "$installation_script_url"
  '';

  meta = with lib; {
    description = "Time tracking software";
    homepage = "https://hubstaff.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ michalrus srghma ];
  };
}
