{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  netsurf-buildsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnsutils";
  version = "0.1.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libnsutils-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-VpS0Um5FjtAAQTzmAnWJy+EKJXp+zwZaAUIdxymd6pI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ netsurf-buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${netsurf-buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "Generalised utility library for netsurf browser";
    license = lib.licenses.mit;
    inherit (netsurf-buildsystem.meta) maintainers platforms;
  };
})
