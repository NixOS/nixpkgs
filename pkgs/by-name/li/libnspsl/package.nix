{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  netsurf-buildsystem,
  publicsuffix-list,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnspsl";
  version = "0.1.7";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libnspsl-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-NoTOwy9VXa7UMZk+C/bL2TdPbJCERiN+CJ8LYdaUrIA=";
  };

  postPatch = ''
    rm public_suffix_list.dat
    ln -s ${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat public_suffix_list.dat
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ netsurf-buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${netsurf-buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "NetSurf Public Suffix List - Handling library";
    license = lib.licenses.mit;
    inherit (netsurf-buildsystem.meta) maintainers platforms;
  };
})
