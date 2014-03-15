{ stdenv, fetchurl
, channel ? "stable"
}:

with stdenv.lib;

let

sources = import ./sources.nix;

libpdf = with (builtins.getAttr channel sources);
stdenv.mkDerivation rec {
  name = "libpdf-${version}";

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
    else throw "libpdf does not support your platform.";

  buildCommand = ''
    ar xv "$src"
    tar xvf data.tar.*

    ensureDir $out/lib
    cp opt/google/chrome*/libpdf.so $out/lib/
    patchelf --set-rpath "${stdenv.gcc.gcc}/lib:${stdenv.gcc.gcc}/lib64" $out/lib/libpdf.so
  '';

  meta = {
    homepage = http://www.google.com/chrome;
    description = "Binary plugin to open PDFs inside the browser";
    license = "unfree";
  };
};

in {
  pepperFlags = "'--register-pepper-plugins=${libpdf}/lib/libpdf.so#Chrome PDF Viewer#Portable Document Format;application/pdf;application/x-google-chrome-print-preview-pdf'";
}
