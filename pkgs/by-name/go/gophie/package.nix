{
  lib,
  stdenv,
  jre,
  makeWrapper,
  jdk,
  makeDesktopItem,
  copyDesktopItems,
  fetchFromGitHub,
  stripJavaArchivesHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gophie";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "jankammerath";
    repo = "gophie";
    tag = finalAttrs.version;
    hash = "sha256-k+Q5+h18LBMxZLhv39+Ky3vq75zDVuxj4TJt9xwixjY=";
  };

  nativeBuildInputs = [
    jdk
    stripJavaArchivesHook
    copyDesktopItems
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    # See https://github.com/jankammerath/gophie/blob/master/make.sh
    javac -d class/ -sourcepath src/ -classpath ".:res/*.ttf:res/*.gif:res/*.png" src/org/gophie/Gophie.java
    cd class
    jar cvfe ../build/Gophie.jar org.gophie.Gophie org/gophie/*.class org/gophie/*/*.class org/gophie/*/*/*.class ../res/*.ttf ../res/*.gif ../res/*.png
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 build/Gophie.jar $out/share/gophie/Gophie.jar

    makeWrapper ${jre}/bin/java $out/bin/Gophie \
      --add-flags "-jar $out/share/gophie/Gophie.jar"

    for size in 16 32 48 128 256 512; do
      install -Dm644 build/icon/gophie-"$size"x"$size".png $out/share/icons/hicolor/"$size"x"$size"/apps/gophie.png
    done

    runHook postInstall
  '';

  # There are no tests.
  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = "gophie";
      exec = finalAttrs.meta.mainProgram;
      icon = "gophie";
      comment = finalAttrs.meta.description;
      desktopName = "Gophie";
      categories = [
        "Network"
        "WebBrowser"
        "Java"
      ];
    })
  ];

  meta = {
    description = "Gophie is a modern, graphical and cross-platform client for the Gopher protocol";
    homepage = "https://github.com/jankammerath/gophie";
    changelog = "https://github.com/jankammerath/gophie/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "Gophie";
    platforms = jdk.meta.platforms;
  };
})
