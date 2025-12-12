{
  maven,
  lib,
  fetchFromGitHub,
  jdk25,
  makeWrapper,
  wrapGAppsHook3,
  glib,
  gtk3,
  libxxf86vm,
  libxtst,
  libGL,
  nix-update-script,
}:
maven.buildMavenPackage rec {
  pname = "convertwithmoss";
  version = "20.3.0";

  src = fetchFromGitHub {
    owner = "git-moss";
    repo = "ConvertWithMoss";
    tag = version;
    hash = "sha256-aPHFxpmCA7SuJhaMKHzx3KotgfCOUd9VJii12wuN8ew=";
  };

  mvnHash = "sha256-2zhpL6af5YAY56yJoVWVffJtsJlcptk6/wpZ0d1aEl4=";
  mvnJdk = jdk25;

  # date 1980-01-01T00:00:00Z is not within the valid range 1980-01-01T00:00:02Z to 2099-12-31T23:59:59Z
  mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/convertwithmoss
    install -Dm644 target/lib/* $out/share/convertwithmoss

    mkdir -p $out/share/{applications,metainfo}
    install -Dm644 linux/de.mossgrabers.ConvertWithMoss.desktop $out/share/applications
    install -Dm644 linux/de.mossgrabers.ConvertWithMoss.appdata.xml $out/share/metainfo
    install -Dm644 icons/convertwithmoss.png $out/share/icons/hicolor/1024x1024/apps/convertwithmoss.png

    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapper ${jdk25}/bin/java $out/bin/convertwithmoss \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          glib
          gtk3
          libxxf86vm
          libxtst
          libGL
        ]
      } \
      --add-flags "-jar $out/share/convertwithmoss/convertwithmoss-${version}.jar"
  '';

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Free multi-sampler converter";
    longDescription = ''
      Converts multisamples from a source format (WAV, multisample, KMP, wavestate, NKI, SFZ, SoundFont 2) to a different destination format.
    '';
    homepage = "https://www.mossgrabers.de/Software/ConvertWithMoss/ConvertWithMoss.html";
    platforms = lib.systems.inspect.patternLogicalAnd lib.systems.inspect.patterns.isLinux lib.systems.inspect.patterns.isx86_64;
    license = [ lib.licenses.lgpl3Plus ];
    maintainers = [ lib.maintainers.mrtnvgr ];
    mainProgram = "convertwithmoss";
  };
}
