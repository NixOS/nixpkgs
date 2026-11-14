{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  librdf_raptor2,
  doCheck ? config.doCheckByDefault or false,
  ladspaPlugins,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lrdf";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "swh";
    repo = "LRDF";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pF3RkzN0p2Ep4j8ZnhC7LSWA2THgX59CaVgBj5abnwM=";
  };

  postPatch = lib.optionalString doCheck ''
    sed -i -e 's:usr/local:${ladspaPlugins}:' examples/{instances,remove}_test.c
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [ librdf_raptor2 ];

  inherit doCheck;

  enableParallelBuilding = true;

  meta = {
    description = "Lightweight RDF library with special support for LADSPA plugins";
    homepage = "https://sourceforge.net/projects/lrdf/";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
