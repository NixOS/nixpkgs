{
  stdenv,
  lib,
  fetchFromGitHub,
  jdk11,
  makeDesktopItem,
  makeWrapper,
  wrapGAppsHook3,
  copyDesktopItems,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "structorizer";
  version = "3.32-35";

  src = fetchFromGitHub {
    owner = "fesch";
    repo = "Structorizer.Desktop";
    rev = version;
    hash = "sha256-ur00Vq+bl+R5MBpmGQO8nX9rEVNMgih1OzWlpY0RDIk=";
  };

  patches = [
    ./makeStructorizer.patch
    ./makeBigJar.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    jdk11
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [ jdk11 ];

  postPatch = ''
    substituteInPlace structorizer.sh --replace "\$DIR/Structorizer.app/Contents/Java/Structorizer.jar" "$out/share/java/structorizer.jar"

    chmod +x makeStructorizer
    chmod +x makeBigJar

    patchShebangs --build makeStructorizer
    patchShebangs --build makeBigJar
  '';

  buildPhase = ''
    runHook preBuild

    ./makeStructorizer
    ./makeBigJar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/bin $out/share/mime/packages $out/share/applications

    install -D structorizer.jar -t $out/share/java/
    cp structorizer.sh $out/bin/structorizer
    wrapProgram $out/bin/structorizer \
      --prefix PATH : ${lib.makeBinPath [ jdk11 ]} \
      --prefix _JAVA_OPTIONS " " "-Dawt.useSystemAAFontSettings=gasp" \
      ''${gappsWrapperArgs[@]}

    cp freedesktop/mime/packages/structorizer.xml $out/share/mime/packages/
    cp freedesktop/applications/structorizer.desktop $out/share/applications/

    cd src/lu/fisch/${pname}/gui
    install -vD icons/000_${pname}.png $out/share/icons/hicolor/16x16/apps/${pname}.png
    for icon_width in 20 24 32 48 64 128 256; do
      install -vD icons_"$icon_width"/000_${pname}.png $out/share/icons/hicolor/"$icon_width"x"$icon_width"/apps/${pname}.png
    done

    runHook postInstall
  '';

  dontWrapGApps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Create Nassi-Shneiderman diagrams (NSD)";
    homepage = "https://structorizer.fisch.lu";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ annaaurora ];
    mainProgram = "structorizer";
  };
}
