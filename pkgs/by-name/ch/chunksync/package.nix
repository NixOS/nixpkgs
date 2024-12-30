{
  lib,
  stdenv,
  fetchurl,
  openssl,
  perl,
}:

stdenv.mkDerivation rec {
  version = "0.4";
  pname = "chunksync";

  src = fetchurl {
    url = "https://chunksync.florz.de/chunksync_${version}.tar.gz";
    sha256 = "1gwqp1kjwhcmwhynilakhzpzgc0c6kk8c9vkpi30gwwrwpz3cf00";
  };

  buildInputs = [
    openssl
    perl
  ];

  NIX_LDFLAGS = "-lgcc_s";

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  meta = {
    description = "Space-efficient incremental backups of large files or block devices";
    mainProgram = "chunksync";
    homepage = "http://chunksync.florz.de/";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
  };
}
