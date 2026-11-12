{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  writeShellScript,
  curl,
  gnugrep,
  gnused,
  coreutils,
  common-updater-scripts,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "crossover";
  version = "26.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://media.codeweavers.com/pub/crossover/cxmac/demo/crossover-${finalAttrs.version}.zip";
    hash = "sha256-hojghIxOX3nxzDUctS0yRH2gDGwAz9O0uy0WTURYmiY=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R CrossOver.app $out/Applications/

    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "crossover-update-script" ''
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

    new_version=$(curl -s "https://www.codeweavers.com/xml/versions/cxmac.xml" \
      | grep -oE 'crossover-[0-9]+\.[0-9]+\.[0-9]+\.zip' \
      | sed -E 's/crossover-(.*)\.zip/\1/' \
      | sort -V \
      | tail -n1)

    if [[ "${finalAttrs.version}" = "$new_version" ]]; then
      echo "crossover is already at the latest version $new_version."
      exit 0
    fi

    update-source-version "crossover" "$new_version" \
      --ignore-same-version
  '';

  meta = {
    description = "Run Windows applications on macOS without a Windows license";
    homepage = "https://www.codeweavers.com/crossover";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.delafthi ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
