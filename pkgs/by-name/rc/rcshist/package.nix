{
  lib,
  stdenv,
  fetchurl,
  musl-fts,
}:

stdenv.mkDerivation {
  pname = "rcshist";
  version = "1.04";

  configureFlags = lib.optional stdenv.hostPlatform.isMusl "LIBS=-lfts";

  buildInputs = lib.optional stdenv.hostPlatform.isMusl musl-fts;

  src = fetchurl {
    url = "https://web.archive.org/web/20220508220019/https://invisible-island.net/datafiles/release/rcshist.tar.gz";
    sha256 = "01ab3xwgm934lxr8bm758am3vxwx4hxx7cc9prbgqj5nh30vdg1n";
  };

  meta = with lib; {
    description = "Utitity to display complete revision history of a set of RCS files";
    homepage = "https://invisible-island.net/rcshist/rcshist.html";
    license = licenses.bsd2;
    maintainers = [ maintainers.kaction ];
    platforms = platforms.unix;
    mainProgram = "rcshist";
  };
}
