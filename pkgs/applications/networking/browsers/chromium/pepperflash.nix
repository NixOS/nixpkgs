{ stdenv, fetchurl
, channel ? "stable"
}:

with stdenv.lib;

let

sources = import ./sources.nix;

pepperflash = with (builtins.getAttr channel sources);
stdenv.mkDerivation rec {
  name = "pepperflash-${version}";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = deb_amd64.url;
        sha1 = deb_amd64.sha1;
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = deb_i386.url;
        sha1 = deb_i386.sha1;
      }
    else throw "pepperflash does not support your platform.";

  buildCommand = ''
    ar xv "$src"
    tar xvf data.tar.*

    ensureDir $out/lib
    cp -r opt/google/chrome*/PepperFlash $out/lib/
    patchelf --set-rpath "${stdenv.gcc.gcc}/lib:${stdenv.gcc.gcc}/lib64" $out/lib/PepperFlash/*.so
  '';

  meta = {
    homepage = http://www.google.com/chrome;
    description = "Binary Adobe Flash plugin distributed in Google Chrome";
    license = "unfree";
  };
};

versionExpr = ''$(sed -n 's/.*"version": "\(.*\)",.*/\1/p' ${pepperflash}/lib/PepperFlash/manifest.json)'';

in {
  pepperFlags = "'--ppapi-flash-path=${pepperflash}/lib/PepperFlash/libpepflashplayer.so' '--ppapi-flash-version=${versionExpr}'";
}
