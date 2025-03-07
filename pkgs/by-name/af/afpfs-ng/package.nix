{
  lib,
  stdenv,
  fetchFromGitHub,
  fuse,
  readline,
  libgcrypt,
  gmp,
}:

stdenv.mkDerivation {
  pname = "afpfs-ng";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "simonvetter";
    repo = "afpfs-ng";
    rev = "f6e24eb73c9283732c3b5d9cb101a1e2e4fade3e";
    sha256 = "125jx1rsqkiifcffyjb05b2s36rllckdgjaf1bay15k9gzhwwldz";
  };

  # Add workaround for -fno-common toolchains like upstream gcc-10 to
  # avoid build failures like:
  #   ld: afpcmd-cmdline_main.o:/build/source/cmdline/cmdline_afp.h:4: multiple definition of
  #    `full_url'; afpcmd-cmdline_afp.o:/build/source/cmdline/cmdline_afp.c:27: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  buildInputs = [
    fuse
    readline
    libgcrypt
    gmp
  ];

  meta = with lib; {
    homepage = "https://github.com/simonvetter/afpfs-ng";
    description = "Client implementation of the Apple Filing Protocol";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.linux;
  };

}
