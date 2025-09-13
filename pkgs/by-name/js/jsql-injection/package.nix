{
  lib,

  jre,

  fetchurl,
  stdenvNoCC,

  makeDesktopItem,
  makeBinaryWrapper,

  copyDesktopItems,
  nix-update-script,
}:

let
  pname = "jsql-injection";
  version = "0.112";

  icon = fetchurl {
    url = "https://www.kali.org/tools/jsql/images/jsql-logo.svg";
    hash = "sha256-qjr+9gMGSdYqDT2SZFt4i3vISrMjqvAlBTt7U6raTLc=";
  };
in
stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    ;

  src = fetchurl {
    url = "https://github.com/ron190/jsql-injection/releases/download/v${version}/jsql-injection-v${version}.jar";
    hash = "sha256-7zBcgEOkncVICnkzeX/nXeCVL8pADE3+6ZittZI22K8=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
  ];

  dontUnpack = true;
  passthru.updateScript = nix-update-script { };

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "jSQL Injection";
      exec = pname;
      icon = pname;
      comment = "Java tool for automatic SQL database injection";
      categories = [
        "Development"
        "Security"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    # Create necessary directories
    mkdir -p $out/share/{applications,${pname}}
    mkdir -p $out/bin

    # Install the JAR file
    cp $src $out/share/${pname}/${pname}.jar

    # Create wrapper
    makeWrapper ${lib.getExe jre} $out/bin/jsql-injection \
      --add-flags "-jar $out/share/${pname}/${pname}.jar"

    # Install icon
    install -Dm444 ${icon} $out/share/icons/hicolor/scalable/apps/${pname}.svg

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/ron190/jsql-injection/releases/tag/v${version}";
    homepage = "https://github.com/ron190/jsql-injection";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    description = "Java tool for automatic SQL database injection";
    mainProgram = "jsql-injection";
    maintainers = with lib.maintainers; [ Masrkai ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
}
