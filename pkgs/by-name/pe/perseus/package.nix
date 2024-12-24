{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation {
  pname = "perseus";
  version = "4-beta";
  nativeBuildInputs = [ unzip ];

  hardeningDisable = [ "stackprotector" ];

  src = fetchurl {
    url = "http://people.maths.ox.ac.uk/nanda/source/perseus_4_beta.zip";
    sha256 = "sha256-cnkJEIC4tu+Ni7z0cKdjmLdS8QLe8iKpdA8uha2MeSU=";
  };

  sourceRoot = ".";
  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++14" ];
  buildPhase = ''
    g++ Pers.cpp -O3 -fpermissive -o perseus
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp perseus $out/bin
  '';

  meta = {
    description = "Persistent Homology Software";
    mainProgram = "perseus";
    longDescription = ''
      Persistent homology - or simply, persistence - is an algebraic
      topological invariant of a filtered cell complex. Perseus
      computes this invariant for a wide class of filtrations built
      around datasets arising from point samples, images, distance
      matrices and so forth.
    '';
    homepage = "http://people.maths.ox.ac.uk/nanda/perseus/index.html";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ erikryb ];
    platforms = lib.platforms.linux;
  };
}
