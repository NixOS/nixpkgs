{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "tthsum";
  version = "1.3.2";

  src = fetchurl {
    url = "http://tthsum.devs.nu/pkg/tthsum-${version}.tar.bz2";
    sha256 = "0z6jq8lbg9rasv98kxfs56936dgpgzsg3yc9k52878qfw1l2bp59";
  };

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp share/tthsum.1.gz $out/share/man/man1
    cp obj-unix/tthsum $out/bin
  '';

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Md5sum-alike program that works with Tiger/THEX hashes";
    longDescription = ''
      tthsum generates or checks TTH checksums (root of the THEX hash
      tree). The Merkle Hash Tree, invented by Ralph Merkle, is a hash
      construct that exhibits desirable properties for verifying the
      integrity of files and file subranges in an incremental or
      out-of-order fashion. tthsum uses the Tiger hash algorithm for
      both the internal and the leaf nodes.

      The specification of the Tiger hash algorithm is at:
      http://www.cs.technion.ac.il/~biham/Reports/Tiger/

      The specification of the THEX algorithm is at:
      http://adc.sourceforge.net/draft-jchapweske-thex-02.html
    '';
    homepage = "http://tthsum.devs.nu/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
    mainProgram = "tthsum";
  };
}
