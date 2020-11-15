{ stdenv, fetchurl
, fuse
, gnunet
, libextractor
, libgcrypt
, libsodium
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "gnunet-fuse";
  version = "0.14.0";

  src = fetchurl {
    url = "mirror://gnu/gnunet/${pname}-${version}.tar.gz";
    sha256 = "sha256-Tn1HDioRnhPk+oyp0rfbWKkL9BXd4JlJn54Ym0MZ13Q=";
  };

  nativeBuildInputs= [
    pkg-config
  ];

  buildInputs = [
    fuse
    gnunet
    libextractor
    libgcrypt
    libsodium
  ];


  meta = gnunet.meta // {
    description = "GNUnet-fuse allows you to mount directories published on GNUnet
as read-only file-systems";
    homepage = "https://git.gnunet.org/gnunet-fuse.git";
  };
}
