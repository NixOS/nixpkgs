{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
  stripJavaArchivesHook,

  glib,
  gtk3,
  gsettings-desktop-schemas,
  libfido2,
  wrapGAppsHook3,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "pdf-over";
  version = "4.4.8";

  src = fetchFromGitHub {
    owner = "a-sit";
    repo = "PDF-Over";
    tag = "pdf-over-${finalAttrs.version}";
    hash = "sha256-CAWNHOFddoKGasT/+AZS/TiehbW586ObAhwlfqbpLq8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  buildInputs = [
    glib
    gtk3
    gsettings-desktop-schemas
    libfido2
  ];

  postPatch = ''
    substituteInPlace pom.xml \
      --replace-fail '2.0.34' '2.0.37'
  '';

  mvnHash = "sha256-VvHkqQmaT3M3cGWqnXpAfYj9E69DKMCBUjYps2bxFE0=";

  nativeBuildInputs = [
    makeWrapper
    stripJavaArchivesHook
    wrapGAppsHook3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r 'pdf-over-gui/target/staging/''${pdfover-build.output-filename}/lib' $out/share/java
    cp -r 'pdf-over-gui/target/staging/''${pdfover-build.output-filename}/icons' $out/share/icons

    runHook postInstall
  '';

  dontWrapGAppsHook = true;

  doCheck = true;

  postFixup = ''
    classpath=$(find $out/share/java -name "*.jar" -printf ':%h/%f');

    makeWrapper ${lib.getExe jre} $out/bin/pdf-over \
          --add-flags "-classpath $out/share/java/pdf-over-gui-${finalAttrs.version}.jar:''${classpath#:}" \
          --add-flags "at.asit.pdfover.gui.Main" \
          ''${gappsWrapperArgs[@]} \
          --prefix LD_LIBRARY_PATH ":" ${
            lib.makeLibraryPath [
              gtk3
              glib
              gsettings-desktop-schemas
              libfido2
            ]
          }
  '';

  meta = {
    description = "eIDAS-compliant PDF-signing tool for the Austrian eGovernment platform";
    longDescription = ''
      A simple, yet configurable eIDAS-compliant PDF-signing tool for the Austrian eGovernment platform
      supporting both FIDO2 L2 certified security tokens and smartphone-based
      signing for creating legally valid qualified signatures on PDFs
    '';
    homepage = "https://technology.a-sit.at/en/pdf-over/";
    license = lib.licenses.eupl12;
    mainProgram = "pdf-over";
    maintainers = with lib.maintainers; [ tanja ];
  };
})
