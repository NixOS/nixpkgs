{
  lib,
  stdenv,
  fetchurl,
  intltool,
  openssl,
  expat,
  libgcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ggz-base-libs";
  version = "0.99.5";

  src = fetchurl {
    url = "http://mirrors.ibiblio.org/pub/mirrors/ggzgamingzone/ggz/snapshots/ggz-base-libs-snapshot-${finalAttrs.version}.tar.gz";
    sha256 = "1cw1vg0fbj36zyggnzidx9cbjwfc1yr4zqmsipxnvns7xa2awbdk";
  };

  nativeBuildInputs = [ intltool ];
  buildInputs = [
    openssl
    expat
    libgcrypt
  ];

  patchPhase = ''
    substituteInPlace configure \
      --replace "/usr/local/ssl/include" "${openssl.dev}/include" \
      --replace "/usr/local/ssl/lib" "${lib.getLib openssl}/lib"
  '';

  configureFlags = [
    "--with-tls"
  ];

  meta = {
    description = "GGZ Gaming zone libraries";
    mainProgram = "ggz-config";
    maintainers = with lib.maintainers; [
      raskin
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
    downloadPage = "http://www.ggzgamingzone.org/releases/";
  };
})
