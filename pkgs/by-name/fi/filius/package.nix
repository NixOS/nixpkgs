{
  lib,
  maven,
  fetchFromGitLab,
  makeWrapper,
  jre,
  wrapGAppsHook3,
  nix-update-script,
}:

maven.buildMavenPackage rec {
  pname = "filius";
  version = "2.9.4";

  src = fetchFromGitLab {
    owner = "filius1";
    repo = "filius";
    # they seem to have stopped using the "v" prefix since 2.9.3
    tag = version;
    hash = "sha256-nQyDPLDQe5kFH3PhCmLqAt8kVnitPwX5K3xLnyntF5k=";
  };

  mvnHash = "sha256-6Qq/7vgA9bWQK+k66qORNwvLKMR1U5yb95DJMWaDq/k=";
  mvnParameters = "-Plinux";

  # tests want to create an X11 window which isn't often feasible
  doCheck = false;

  postPatch = ''
    substituteInPlace src/deb/filius.desktop \
      --replace-fail 'Exec=/usr/share/filius/filius.sh' 'Exec=filius'
  '';

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}
    cp -r target/* $out/share/${pname}

    # GTK_THEME is not just set to adwaita, but to the *light* adwaita because otherwise the application is sort of unusable. the terminal still has unreadable text though (light on light).
    # Without _JAVA_AWT_WM_NONREPARENTING, if you launch filius, it's just a white window, i.e. broken.
    makeWrapper ${lib.getExe' jre "java"} $out/bin/${pname} \
      --set GTK_THEME 'Adwaita' \
      --set _JAVA_AWT_WM_NONREPARENTING '1' \
      --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=lcd' \
      --add-flags "-jar $out/share/${pname}/${pname}.jar" \

    runHook postInstall
  '';

  postInstall = ''
    install -Dm444 src/deb/application-filius-project.xml $out/share/mime/packages/application-filius-project.xml

    install -Dm444 src/deb/filius32.png $out/share/icons/hicolor/80x56/mimetypes/filius.png
    install -Dm444 src/deb/filius32.png $out/share/icons/hicolor/80x56/apps/filius.png

    mkdir -p $out/share/man/man1/
    cp src/deb/filius.1 $out/share/man/man1/

    mkdir -p $out/share/applications
    cp src/deb/filius.desktop $out/share/applications/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.lernsoftware-filius.de/";
    # note, the gitlab repo page is *not* the homepage and there is not meta attribute for their git forge page
    downloadPage = "https://www.lernsoftware-filius.de/Herunterladen";
    description = "A computer network simulator for secondary schools";
    longDescription = ''
      With the software tool Filius, you can design computer networks yourself,
      simulate the exchange of messages in them and thus explore their structure
      and functionality experimentally. The target group are pupils at secondary
      schools (general education). Filius enables learning activities that
      are designed to support discovery-based learning in particular.
    '';
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
    ];
    maintainers = with lib.maintainers; [ annaaurora ];
    platforms = lib.platforms.all;
    mainProgram = "filius";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
