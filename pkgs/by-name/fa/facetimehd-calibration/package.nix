{ lib, stdenvNoCC, fetchurl, unrar-wrapper, pkgs }:

let

  version = "5.1.5769";


  # Described on https://github.com/patjak/facetimehd/wiki/Extracting-the-sensor-calibration-files

  # From the wiki page, range extracted with binwalk:
  zipUrl = "https://download.info.apple.com/Mac_OS_X/031-30890-20150812-ea191174-4130-11e5-a125-930911ba098f/bootcamp${version}.zip";
  zipRange = "2338085-3492508"; # the whole download is 518MB, this deflate stream is 1.2MB

  # CRC and length from the ZIP entry header (not strictly necessary, but makes it extract cleanly):
  gzFooter = ''\x51\x1f\x86\x78\xcf\x5b\x12\x00'';

  # Also from the wiki page:
  calibrationFiles = [
    { file = "1771_01XX.dat"; offset = "1644880"; size = "19040"; }
    { file = "1871_01XX.dat"; offset = "1606800"; size = "19040"; }
    { file = "1874_01XX.dat"; offset = "1625840"; size = "19040"; }
    { file = "9112_01XX.dat"; offset = "1663920"; size = "33060"; }
  ];

in

stdenvNoCC.mkDerivation {

  pname = "facetimehd-calibration";
  inherit version;
  src = fetchurl {
    url = zipUrl;
    sha256 = "1dzyv457fp6d8ly29sivqn6llwj5ydygx7p8kzvdnsp11zvid2xi";
    curlOpts = "-r ${zipRange}";
  };

  dontUnpack = true;
  dontInstall = true;

  buildInputs = [ unrar-wrapper ];

  buildPhase = ''
    { printf '\x1f\x8b\x08\x00\x00\x00\x00\x00\x00\x00'
      cat $src
      printf '${gzFooter}'
    } | zcat > AppleCamera64.exe
    unrar x AppleCamera64.exe AppleCamera.sys

    mkdir -p $out/lib/firmware/facetimehd
  '' + lib.concatMapStrings ({file, offset, size}: ''
    dd bs=1 skip=${offset} count=${size} if=AppleCamera.sys of=$out/lib/firmware/facetimehd/${file}
  '') calibrationFiles;

  meta = with lib; {
    description = "facetimehd calibration";
    homepage = "https://support.apple.com/kb/DL1837";
    license = licenses.unfree;
    maintainers = with maintainers; [ alexshpilkin womfoo grahamc ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

}
