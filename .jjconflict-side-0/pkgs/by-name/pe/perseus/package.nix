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

  strictDeps = true;
  __structuredAttrs = true;

  hardeningDisable = [ "stackprotector" ];

  src = fetchurl {
    url = "https://people.maths.ox.ac.uk/nanda/source/perseus_4_beta.zip";
    hash = "sha256-cnkJEIC4tu+Ni7z0cKdjmLdS8QLe8iKpdA8uha2MeSU=";
  };

  sourceRoot = ".";

  patches = [
    ./fix-gcc15.patch
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++14" ];
  buildPhase = ''
    runHook preBuild
    g++ Pers.cpp -O3 -fpermissive -o perseus
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp perseus $out/bin
    runHook postInstall
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
    homepage = "https://people.maths.ox.ac.uk/nanda/perseus/index.html";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      erikryb
      coolcuber
    ];
    platforms = lib.platforms.linux;
  };
}
