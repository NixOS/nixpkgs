{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cproto";
  version = "4.7y";

  src = fetchurl {
    urls = [
      "mirror://debian/pool/main/c/cproto/cproto_${finalAttrs.version}.orig.tar.gz"
      # No version listings and apparently no versioned tarball over http(s).
      "https://invisible-island.net/archives/cproto/cproto-${finalAttrs.version}.tgz"
    ];
    sha256 = "sha256-C9HYvo/wpMpD+Uf5V1DTT2TtqTyeLKeRAP1gFAt8YzE=";
  };

  # patch made by Joe Khoobyar copied from gentoo bugs
  patches = [ ./cproto.patch ];

  nativeBuildInputs = [
    flex
    bison
  ];

  doCheck = true;

  doInstallCheck = true;
  installCheckPhase = ''
    [ "$("$out/bin/cproto" -V 2>&1)" = '${finalAttrs.version}' ]
  '';

  meta = {
    description = "Tool to generate C function prototypes from C source code";
    mainProgram = "cproto";
    homepage = "https://invisible-island.net/cproto/";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
  };
})
