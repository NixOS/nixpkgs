{ stdenv, lib, fetchurl, pkgconfig, zathura_core, gtk, girara, mupdf, openssl
, libjpeg, jbig2dec, openjpeg, fetchpatch }:

stdenv.mkDerivation rec {
  version = "0.3.0";
  name = "zathura-pdf-mupdf-${version}";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-pdf-mupdf/download/${name}.tar.gz";
    sha256 = "1j3j3wbp49walb19f0966qsnlqbd26wnsjpcxfbf021dav8vk327";
  };

  buildInputs = [ pkgconfig zathura_core gtk girara openssl mupdf libjpeg jbig2dec openjpeg ];

  makeFlags = [ "PREFIX=$(out)" "PLUGINDIR=$(out)/lib" ];

  patches = [(fetchpatch {
    name = "mupdf-1.9.patch";
    url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/mupdf-1.9.patch?h=packages/zathura-pdf-mupdf&id=385ad96261b7297fdebbee6f4b22ec20dda8d65e";
    sha256 = "185wgg0z4b0z5aybcnnyvbs50h43imn5xz3nqmya4rk4v5bwy49y";
  })];

  meta = with lib; {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura PDF plugin (mupdf)";
    longDescription = ''
      The zathura-pdf-mupdf plugin adds PDF support to zathura by
      using the mupdf rendering library.
    '';
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
