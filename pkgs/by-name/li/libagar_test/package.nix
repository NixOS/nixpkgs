{
  lib,
  stdenv,
  libagar,
  perl,
  libjpeg,
  libpng,
  openssl,
}:
stdenv.mkDerivation {
  pname = "libagar-test";
  inherit (libagar) version src;

  sourceRoot = "agar-${libagar.version}/tests";

  configureFlags = [ "--with-agar=${libagar}" ];

  buildInputs = [
    perl
    libagar
    libjpeg
    libpng
    openssl
  ];

  meta = {
    description = "Tests for libagar";
    mainProgram = "agartest";
    homepage = "http://libagar.org/index.html";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ ramkromberg ];
    platforms = lib.platforms.linux;
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
  };
}
