{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
}:
maven.buildMavenPackage (finalAttrs: {
  pname = "megabasterd";
  version = "8.61";

  src = fetchFromGitHub {
    owner = "tonikelope";
    repo = "megabasterd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H3nW+phtT30nhKIBxlS3CAqVxFIWcBvStbNlnobWEiQ=";
  };

  mvnHash = "sha256-JZ8INISDHPVhxylKwQc2DybPqxfwcGpkWxDhq8Fpqt8=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    jar_filename=MegaBasterd-${finalAttrs.version}-jar-with-dependencies.jar

    mkdir -p $out/bin $out/share/megabasterd
    install -Dm644 target/$jar_filename $out/share/megabasterd

    makeWrapper ${jre}/bin/java $out/bin/megabasterd \
      --add-flags "-jar $out/share/megabasterd/$jar_filename"

    runHook postInstall
  '';

  meta = {
    description = "Yet another unofficial (and ugly) cross-platform MEGA downloader/uploader/streaming suite";
    homepage = "https://github.com/tonikelope/megabasterd";
    changelog = "https://github.com/tonikelope/megabasterd/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "megabasterd";
  };
})
