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
  version = "1.9.0";

  src = fetchurl {
    url = "https://github.com/MorpheApp/morphe-cli/releases/download/v${finalAttr.version}/morphe-cli-${finalAttr.version}-all.jar";
    hash = "sha256-cHxWaqqEqMY6Log6ccsep/VeHjwIjEJs0Gss0fl9Pmk=";
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

    mkdir -p "$prefix/bin" "$out/share/doc/morphe-cli" "$out/share/morphe-cli"
    install -Dm644 "$src" $out/share/morphe-cli.jar

    makeWrapper ${jre}/bin/java $out/bin/morphe-cli \
      --add-flags "-jar $out/share/morphe-cli.jar" \
      --prefix PATH : "${lib.makeBinPath [ ]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \

    unzip -p "$src" NOTICE > "$out/share/doc/morphe-cli/NOTICE"

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
