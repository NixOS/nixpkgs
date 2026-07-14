{
  lib,
  stdenv,
  fetchurl,
  unzip,
  cmake,
  doxygen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bliss";
  version = "0.77";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://users.aalto.fi/~tjunttil/bliss/downloads/bliss-${finalAttrs.version}.zip";
    hash = "sha256-rMi5gDTzD60kyJfzZavYZsE9nxuyB+OY0MrxNodZcqQ=";
  };

  patches = [
    (fetchurl {
      url = "https://github.com/sagemath/sage/raw/0fc563cc566ac4e9d0b713195d0a4fb138abca06/build/pkgs/bliss/patches/bliss-0.77-install.patch";
      hash = "sha256-x2xTfR98eipLxskqHEwFBT9xciwFOFpeJWfg4IcepKQ=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    unzip
    cmake
    doxygen
  ];

  postBuild = ''
    doxygen ../Doxyfile
  '';

  postInstall = ''
    mkdir -p $out/share/doc/bliss
    mv html/* ../COPYING* $out/share/doc/bliss
  '';

  meta = {
    description = "Open source tool for computing automorphism groups and canonical forms of graphs";
    mainProgram = "bliss";
    homepage = "https://users.aalto.fi/~tjunttil/bliss/";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.all;
  };
})
