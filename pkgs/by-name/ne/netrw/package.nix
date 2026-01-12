{
  lib,
  stdenv,
  fetchurl,
  checksumType ? "built-in",
  libmhash ? null,
  openssl ? null,
}:

assert checksumType == "mhash" -> libmhash != null;
assert checksumType == "openssl" -> openssl != null;

stdenv.mkDerivation rec {
  pname = "netrw";
  version = "1.3.2";

  configureFlags = [
    # This is to add "#include" directives for stdlib.h, stdio.h and string.h.
    "ac_cv_header_stdc=yes"

    "--with-checksum=${checksumType}"
  ];

  buildInputs =
    lib.optional (checksumType == "mhash") libmhash ++ lib.optional (checksumType == "openssl") openssl;

  src = fetchurl {
    urls = [
      "https://mamuti.net/files/netrw/netrw-${version}.tar.bz2"
      "http://www.sourcefiles.org/Networking/FTP/Other/netrw-${version}.tar.bz2"
    ];
    sha256 = "1gnl80i5zkyj2lpnb4g0q0r5npba1x6cnafl2jb3i3pzlfz1bndr";
  };

  meta = {
    description = "Simple tool for transporting data over the network";
    license = lib.licenses.gpl2Plus;
    homepage = "https://mamuti.net/netrw/index.en.html";
    platforms = lib.platforms.unix;
  };
}
