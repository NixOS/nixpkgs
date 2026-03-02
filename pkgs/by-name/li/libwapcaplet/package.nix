{
  lib,
  stdenv,
  fetchurl,
  netsurf-buildsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwapcaplet";
  version = "0.4.3";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libwapcaplet-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-myqh3W1mRfjpkrNpf9vYfwwOHaVyH6VO0ptITRMWDFw=";
  };

  buildInputs = [ netsurf-buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${netsurf-buildsystem}/share/netsurf-buildsystem"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=cast-function-type";

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libwapcaplet/";
    description = "String internment library for netsurf browser";
    license = lib.licenses.mit;
    inherit (netsurf-buildsystem.meta) maintainers platforms;
  };
})
