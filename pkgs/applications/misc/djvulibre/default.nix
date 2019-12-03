{ stdenv, fetchurl, libjpeg, libtiff, librsvg, libiconv }:

stdenv.mkDerivation rec {
  name = "djvulibre-3.5.27";

  src = fetchurl {
    url = "mirror://sourceforge/djvu/${name}.tar.gz";
    sha256 = "0psh3zl9dj4n4r3lx25390nx34xz0bg0ql48zdskhq354ljni5p6";
  };

  outputs = [ "bin" "dev" "out" ];

  buildInputs = [ libjpeg libtiff librsvg libiconv ];

  patches = [
    ./CVE-2019-18804.patch
    # This one is needed to make the following
    # two CVE patches apply cleanly
    ./fix_hongfuzz_crash.patch
    ./CVE-2019-15142.patch
    ./CVE-2019-15143.patch
    ./CVE-2019-15144.patch
    ./CVE-2019-15145.patch
  ];

  meta = with stdenv.lib; {
    description = "A library and viewer for the DJVU file format for scanned images";
    homepage = http://djvu.sourceforge.net;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
