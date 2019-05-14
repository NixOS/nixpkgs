{ stdenv, fetchurl, unzip, makeWrapper, libX11, zlib, libSM, libICE
, libXext , freetype, libXrender, fontconfig, libXft, libXinerama
, libXfixes, libXScrnSaver, libnotify, glib , gtk3, libappindicator-gtk3
, curl }:

let

  data = builtins.fromJSON (builtins.readFile ./revision.json);

  inherit (data) version url sha256;

  rpath = stdenv.lib.makeLibraryPath
    [ libX11 zlib libSM libICE libXext freetype libXrender fontconfig libXft
      libXinerama stdenv.cc.cc.lib libnotify glib gtk3 libappindicator-gtk3
      curl libXfixes libXScrnSaver ];

in

stdenv.mkDerivation {
  name = "hubstaff-${version}";

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

  meta = with stdenv.lib; {
    description = "Time tracking software";
    homepage = https://hubstaff.com/;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.michalrus ];
  };
}
