{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  makeBinaryWrapper,
  writeShellScript,
  curl,
  gnugrep,
  gnused,
  coreutils,
  common-updater-scripts,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kicad-bin";
  version = "10.0.6";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://s3.cern.ch/kicad-downloads/osx/stable/kicad-unified-universal-${finalAttrs.version}.dmg";
    hash = "sha256-703NQnjEbT780oyNsnPVlX1o79oCj2v3m0gR/FMC3Gg=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    _7zz
    makeBinaryWrapper
  ];

  unpackPhase = ''
    runHook preUnpack

    7zz -snld x $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv KiCad/KiCad/KiCad.app $out/Applications/
    makeBinaryWrapper "$out/Applications/KiCad.app/Contents/MacOS/kicad" "$out/bin/kicad"
    makeBinaryWrapper "$out/Applications/KiCad.app/Contents/MacOS/kicad-cli" "$out/bin/kicad-cli"

    runHook postInstall
  '';

  passthru = {
    updateScript = writeShellScript "kicad-bin-update-script" ''
      set -euo pipefail
      export PATH="${
        lib.makeBinPath [
          curl
          gnugrep
          gnused
          coreutils
          common-updater-scripts
        ]
      }"

      new_version=$(curl -s "https://s3.cern.ch/kicad-downloads/?list-type=2&prefix=osx/stable/kicad-unified-universal-" \
        | grep -oE 'kicad-unified-universal-[0-9]+\.[0-9]+\.[0-9]+\.dmg' \
        | sed -E 's/kicad-unified-universal-(.*)\.dmg/\1/' \
        | sort -V \
        | tail -n1)

      if [[ "${finalAttrs.version}" = "$new_version" ]]; then
        echo "kicad-bin is already at the latest version $new_version."
        exit 0
      fi

      update-source-version "kicad-bin" "$new_version" \
        --ignore-same-version
    '';
  };

  meta = {
    description = "EDA suite for schematic and PCB design";
    homepage = "https://www.kicad.org/";
    changelog = "https://www.kicad.org/blog/categories/Release-Notes/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.delafthi ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "kicad";
  };
})
