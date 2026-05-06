{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  libGL,
  unzip,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttr: {
  pname = "morphe-cli";
  version = "1.8.0";

  src = fetchurl {
    url = "https://github.com/MorpheApp/morphe-cli/releases/download/v${finalAttr.version}/morphe-cli-${finalAttr.version}-all.jar";
    hash = "sha256-4cqYKiBWJWuQg+UkuBMYRFS7SkEq1Dw+wMPihkuKVwQ=";
  };

  __structuredAttrs = true;

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    unzip
    wrapGAppsHook3
  ];
  buildInputs = [
    jre
    libGL
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$prefix/bin" "$out/share/doc/${finalAttr.pname}"

    makeWrapper ${jre}/bin/java $out/bin/morphe-cli \
      --add-flags "-jar $src" \
      --prefix PATH : "$PATH" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \

    unzip -p "$src" NOTICE > "$out/share/doc/${finalAttr.pname}/NOTICE"

    runHook postInstall
  '';

  meta = {
    description = "Command-line application that uses Morphe Patcher to patch Android apps";
    homepage = "https://github.com/MorpheApp/morphe-cli";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = [ lib.maintainers.hetraeus ];
    mainProgram = "morphe-cli";
  };
})
