{
  lib,
  maven,
  fetchFromGitHub,
  jdk17,
  makeWrapper,
  makeDesktopItem,
  libxxf86vm,
  libxtst,
  libGL,
  openjfx17,
  gtk3,
  wrapGAppsHook3,
  glib,
  mesa,
}:

maven.buildMavenPackage rec {
  pname = "karedi";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "Nianna";
    repo = "Karedi";
    tag = "v${version}";
    hash = "sha256-iXWYUOR+9fJGDWzsYOLXQSc7f2n7n0i34pQO5T6nx6w=";
  };

  mvnHash = "sha256-TJurbsbsslo6rSzVeuHWuewhxzN8F99/EsrsArTKoKE=";
  mvnJdk = jdk17;

  nativeBuildInputs = [
    jdk17
    makeWrapper
    wrapGAppsHook3
  ];
  buildInputs = [
    libxxf86vm
    libxtst
    libGL
    openjfx17
    gtk3
    glib
    mesa
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/karedi
    install -Dm644 target/dist/Karedi-${version}.jar $out/share/karedi

    makeWrapper ${jdk17}/bin/java $out/bin/karedi \
      --add-flags "-jar $out/share/karedi/Karedi-${version}.jar" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxxf86vm
          libxtst
          libGL
          gtk3
          glib
          mesa
        ]
      }"

    ln -s "$desktopItem/share/applications" "$out/share/"

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Karedi";
    exec = "karedi";
    icon = "${src}/src/main/resources/icon/icon.png";
  };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Multi-platform graphical editor & creator for UltraStar songs";
    homepage = "https://github.com/Nianna/Karedi";
    license = with lib.licenses; [ gpl3 ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mooses ];
    mainProgram = "karedi";
  };
}
