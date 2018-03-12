{ stdenv
, fetchurl
, dbus
, expat, zlib, fontconfig
, libpng, libX11, libxcb, libXau, libXdmcp, freetype, libbsd
}:

with stdenv.lib;
let
  libPath = makeLibraryPath
    [ stdenv.cc.cc dbus libX11 zlib libX11 libxcb libXau libXdmcp freetype fontconfig libbsd ];

  version = "2016-1-17";

  mainbin = "SoulseekQt-" + (version) +"-"+ (if stdenv.is64bit then "64bit" else "32bit");
  srcs = {
    "i686-linux" = fetchurl {
      url = "https://www.dropbox.com/s/kebk1b5ib1m3xxw/${mainbin}.tgz";
      sha256 = "0r9rhnfslkgbw3l7fnc0rcfqjh58amgh5p33kwam0qvn1h1frnir";
    };

    "x86_64-linux" = fetchurl {
      url = "https://www.dropbox.com/s/7qh902qv2sxyp6p/${mainbin}.tgz";
      sha256 = "05l3smpdvw8xdhv4v8a28j0yi1kvzhrha2ck23g4bl7x9wkay4cc";
    };
  };

in stdenv.mkDerivation rec {

  name = "soulseekqt-${version}";
  inherit version;
  src = srcs."${stdenv.system}" or (throw "unsupported system: ${stdenv.system}");

  sourceRoot = ".";
  buildPhase = ":";   # nothing to build

  installPhase = ''
    mkdir -p $out/bin
    cp ${mainbin} $out/bin/soulseekqt
  '';

  fixupPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath ${libPath} \
             $out/bin/soulseekqt
  '';

  meta = with stdenv.lib; {
    description = "Official Qt SoulSeek client";
    homepage = http://www.soulseekqt.net;
    license = licenses.unfree;
    maintainers = [ maintainers.genesis ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
