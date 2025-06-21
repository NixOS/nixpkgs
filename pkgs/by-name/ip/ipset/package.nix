{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libmnl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ipset";
  version = "7.24";

  src = fetchurl {
    url = "https://ipset.netfilter.org/ipset-${finalAttrs.version}.tar.bz2";
    hash = "sha256-++NCTf8iLBy15cNNOLZFJLIhfOgCJsFP3LsTsp6jYRI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  configureFlags = [ "--with-kmod=no" ];

  meta = with lib; {
    homepage = "https://ipset.netfilter.org/";
    description = "Administration tool for IP sets";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "ipset";
  };
})
