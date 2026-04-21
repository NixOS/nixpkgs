{
  stdenv,
  lib,
  fetchurl,
  unzip,
  copyDesktopItems,
  makeDesktopItem,
  jre8,
}:

let
in
stdenv.mkDerivation (finalAttrs: {
  version = "16.3.49";
  pname = "jmol";

  nativeBuildInputs = [ copyDesktopItems ];

  src =
    let
      baseVersion = "${lib.versions.major finalAttrs.version}.${lib.versions.minor finalAttrs.version}";
    in
    fetchurl {
      url = "mirror://sourceforge/jmol/Jmol/Version%20${baseVersion}/Jmol%20${finalAttrs.version}/Jmol-${finalAttrs.version}-binary.tar.gz";
      hash = "sha256-OOHqRgkgG51o8mxo7lDAEQeCFoBSxdwdX72CUYdmRKw=";
    };

  patchPhase = ''
    sed -i -e "4s:.*:command=${jre8}/bin/java:" -e "10s:.*:jarpath=$out/share/jmol/Jmol.jar:" -e "11,21d" jmol
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/jmol" "$out/bin"

    ${unzip}/bin/unzip jsmol.zip -d "$out/share/"

    cp *.jar jmol.sh "$out/share/jmol"
    cp jmol $out/bin

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "jmol";
      exec = "jmol";
      desktopName = "JMol";
      genericName = "Molecular Modeler";
      mimeTypes = [
        "chemical/x-pdb"
        "chemical/x-mdl-molfile"
        "chemical/x-mol2"
        "chemical/seq-aa-fasta"
        "chemical/seq-na-fasta"
        "chemical/x-xyz"
        "chemical/x-mdl-sdf"
      ];
      categories = [
        "Graphics"
        "Education"
        "Science"
        "Chemistry"
      ];
    })
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Java 3D viewer for chemical structures";
    mainProgram = "jmol";
    homepage = "https://sourceforge.net/projects/jmol";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.all;
    teams = [ lib.teams.sage ];
  };
})
