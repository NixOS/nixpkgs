{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "galleta";
  version = "20040505_1";

  src = fetchzip {
    url = "mirror://sourceforge/project/odessa/Galleta/${finalAttrs.version}/galleta_${finalAttrs.version}.zip";
    hash = "sha256-tc5XLToyQZutb51ZoBlGWXDpsSqdJ89bjzJwY8kRncA=";
  };

  makeFlags = [
    "-C src"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp bin/galleta $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Examine the contents of the IE's cookie files for forensic purposes";
    mainProgram = "galleta";
    homepage = "https://sourceforge.net/projects/odessa/files/Galleta";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
})
