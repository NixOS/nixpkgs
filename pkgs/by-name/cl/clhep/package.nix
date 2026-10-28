{
  lib,
  stdenv,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clhep";
  version = "2.4.7.1";

  src = fetchurl {
    url = "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-${finalAttrs.version}.tgz";
    hash = "sha256-HIMEp3cqxrmRlfEwA3jG4930rQfIXWSgRQVlKruKVfk=";
  };

  prePatch = ''
    cd CLHEP
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "clhep_ensure_out_of_source_build()" ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Set of HEP-specific foundation and utility classes such as random generators, physics vectors, geometry and linear algebra";
    homepage = "https://cern.ch/clhep";
    license = with lib.licenses; [
      gpl3Only
      lgpl3Only
    ];
    maintainers = with lib.maintainers; [ veprbl ];
    platforms = lib.platforms.unix;
  };
})
