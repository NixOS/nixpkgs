{
  lib,
  stdenv,
  fetchFromGitHub,
  libpng,
  libjpeg,
  zlib,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "poisson-recon";
  version = "16.04";

  src = fetchFromGitHub {
    owner = "mkazhdan";
    repo = "PoissonRecon";
    # Commit msg says "Version 16.04", there's just no tag
    rev = "e04a91d40093dd80669afb07f7d3f586db063ee9";
    hash = "sha256-vTwU84yFaAwojGMFowf0AoSCNhKHkXL32kNY4WH5goY=";
  };

  buildInputs = [
    boost
    libpng
    libjpeg
    zlib
  ];

  preConfigure = ''
    for path in "''${pkgsHostTarget[@]}" ; do
      if [[ -d "$path/include" ]] ; then
        NIX_CFLAGS_COMPILE+=" -I$path/include"
      fi
    done
    NIX_CFLAGS_COMPILE+=" -I$PWD"
    NIX_CFLAGS_COMPILE+=" -I$PWD/Src"
    export NIX_CFLAGS_COMPILE
  '';

  # E.g. Open3D uses "#include "PoissonRecon/Src/PointStreamData.h"
  includePrefix = "PoissonRecon";

  installPhase = ''
    runHook preInstall

    while IFS= read -r -d $'\0' path ; do
      if [[ ! -d "''${!outputLib}/lib" ]] ; then
        mkdir -p "''${!outputLib}/lib"
      fi
      cp "$path" "''${!outputLib}/lib"/
    done < <( find \( -iname '*.so' -o -iname '*.a' \) -print0 )

    while IFS= read -r -d $'\0' relPath ; do
      local dirName="''${includePrefix}/$(dirname "$relPath")"
      if [[ ! -d "''${!outputInclude}/include/$dirName" ]] ; then
        mkdir -p "''${!outputInclude}/include/$dirName"
      fi
      cp "$relPath" "''${!outputInclude}/include/$includePrefix/$relPath"
    done < <( find \( -iname '*.h' -o -iname '*.inl' \) -print0 )

    while IFS= read -r -d $'\0' relPath ; do
      if [[ ! -d "''${!outputBin}/bin" ]] ; then
        mkdir -p "''${!outputBin}/bin"
      fi
      cp "$relPath" "''${!outputBin}/bin"
    done < <( find \( -executable -a -type f \) -print0 )

    runHook postInstall
  '';

  meta = {
    description = "Poisson Surface Reconstruction";
    homepage = "https://github.com/isl-org/Open3D-PoissonRecon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
    mainProgram = "poisson-recon";
    platforms = lib.platforms.all;
  };
}
