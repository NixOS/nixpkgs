{ lib
, stdenv
, fetchFromGitLab
, makeBinaryWrapper
, jre
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oscanner";
  version = "1.0.6";

  src = fetchFromGitLab {
    group = "kalilinux";
    owner = "packages";
    repo = "oscanner";
    rev = "upstream/${finalAttrs.version}";
    hash = "sha256-7/+/W6HsCaopHwCHEftwBUGNoZ+iDX+6WQLnBNFE6B4=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    PREFIX="$out/share/oscanner"
    cp -r . $PREFIX
    makeWrapper $PREFIX/oscanner.sh $out/bin/oscanner \
      --chdir $PREFIX \
      --prefix PATH : "${lib.makeBinPath [ jre ]}"

    runHook postInstall
  '';

  meta = {
    description = "Oracle assessment framework developed in Java";
    # Original homepage is offline http://www.cqure.net/wp/tools/database/oscanner/
    homepage = "https://www.kali.org/tools/oscanner/";
    license = lib.licenses.gpl2Only;
    mainProgram = "oscanner";
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
