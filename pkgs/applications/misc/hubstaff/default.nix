{ stdenv, fetchurl, unzip, makeWrapper, libX11, zlib, libSM, libICE, libXext
, freetype, libXrender, fontconfig, libXft, libXinerama, libnotify, glib
, gtk3, libappindicator-gtk3, curl }:

let

  version = "1.2.15-590e8bc";

  rpath = stdenv.lib.makeLibraryPath
    [ libX11 zlib libSM libICE libXext freetype libXrender fontconfig libXft
      libXinerama stdenv.cc.cc.lib libnotify glib gtk3 libappindicator-gtk3
      curl ];

in

stdenv.mkDerivation {
  name = "hubstaff-${version}";

  src = fetchurl {
    url = "https://hubstaff-production.s3.amazonaws.com/downloads/HubstaffClient/Builds/Release/${version}/Hubstaff-${version}.sh";
    sha256 = "142q8xvwn5gdmpv5x25py2lindr74jqncf8vvw22yb9nj5aqqsi6";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackCmd = ''
    # MojoSetups have a ZIP file at the end. ZIP’s magic string is
    # most often PK\x03\x04. This *should* work for future updates,
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

    opt=$out/opt/hubstaff
    mkdir -p $out/bin $opt
    cp -r . $opt/

    prog=$opt/x86_64/HubstaffClient.bin.x86_64

    patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) $prog
    wrapProgram $prog --prefix LD_LIBRARY_PATH : ${rpath}

    ln -s $prog $out/bin/HubstaffClient

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
