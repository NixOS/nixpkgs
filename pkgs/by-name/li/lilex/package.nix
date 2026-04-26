{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "lilex";
  version = "2.700";

  src = fetchurl {
    url = "https://github.com/mishamyrt/Lilex/releases/download/${version}/Lilex.zip";
    hash = "sha256-NDEO20unSfdy1CuI4+7EpjGFJ+dc7qqWz8VW7jU2b7w=";
  };

  nativeBuildInputs = [
    installFonts
    unzip
  ];

  unpackPhase = ''
    runHook preUnpack
    unzip $src
    runHook postUnpack
  '';

  meta = {
    description = "Open source programming font";
    homepage = "https://github.com/mishamyrt/Lilex";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ redyf ];
    platforms = lib.platforms.all;
  };
}
