{ lib
, stdenv
, fetchFromGitHub
, makeDesktopItem
, makeWrapper
, wrapGAppsHook
, stripJavaArchivesHook
, ant
, jdk
, jre
, gtk2
, glib
, libXtst
, Cocoa
}:

let
  _version = "2.10.4";
  _build = "487";
  version = "${_version}-${_build}";

  swtSystem =
    if stdenv.hostPlatform.system == "i686-linux" then "linux"
    else if stdenv.hostPlatform.system == "x86_64-linux" then "linux64"
    else if stdenv.hostPlatform.system == "aarch64-linux" then "linux-arm64"
    else if stdenv.hostPlatform.system == "x86_64-darwin" then "macos64"
    else throw "Unsupported system: ${stdenv.hostPlatform.system}";

  desktopItem = makeDesktopItem {
    name = "jameica";
    exec = "jameica";
    comment = "Free Runtime Environment for Java Applications.";
    desktopName = "Jameica";
    genericName = "Jameica";
    icon = "jameica";
    categories = [ "Office" ];
  };
in
stdenv.mkDerivation rec {
  pname = "jameica";
  inherit version;

  src = fetchFromGitHub {
    owner = "willuhn";
    repo = "jameica";
    rev = "V_${builtins.replaceStrings ["."] ["_"] _version}_BUILD_${_build}";
    hash = "sha256-MSVSd5DyVL+dcfTDv1M99hxickPwT2Pt6QGNsu6DGZI=";
  };

  nativeBuildInputs = [ ant jdk wrapGAppsHook makeWrapper stripJavaArchivesHook ];
  buildInputs = lib.optionals stdenv.isLinux [ gtk2 glib libXtst ]
    ++ lib.optional stdenv.isDarwin Cocoa;

  dontWrapGApps = true;

  # there is also a build.gradle, but it only seems to be used to vendor 3rd party libraries
  # and is not able to build the application itself
  buildPhase = ''
    runHook preBuild
    ant -f build -Dsystem.version=${version} init compile jar
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec $out/lib $out/bin $out/share/{applications,jameica-${version},java}/

    # copy libraries except SWT
    cp $(find lib -type f -iname '*.jar' | grep -ve 'swt/.*/swt.jar') $out/share/jameica-${version}/
    # copy platform-specific SWT
    cp lib/swt/${swtSystem}/swt.jar $out/share/jameica-${version}/

    install -Dm644 releases/${_version}-*/jameica/jameica.jar $out/share/java/
    install -Dm644 plugin.xml $out/share/java/
    install -Dm644 build/jameica-icon.png $out/share/pixmaps/jameica.png
    cp ${desktopItem}/share/applications/* $out/share/applications/

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${jre}/bin/java $out/bin/jameica \
      --add-flags "-cp $out/share/java/jameica.jar:$out/share/jameica-${version}/* ${
        lib.optionalString stdenv.isDarwin ''-Xdock:name="Jameica" -XstartOnFirstThread''
      } de.willuhn.jameica.Main" \
      --prefix LD_LIBRARY_PATH : ${lib.escapeShellArg (lib.makeLibraryPath buildInputs)} \
      --chdir "$out/share/java/" \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = with lib; {
    homepage = "https://www.willuhn.de/products/jameica/";
    description = "Free Runtime Environment for Java Applications";
    longDescription = ''
      Runtime Environment for plugins like Hibiscus (HBCI Online Banking),
      SynTAX (accounting) and JVerein (club management).
    '';
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
    ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" ];
    maintainers = with maintainers; [ flokli r3dl3g ];
    mainProgram = "jameica";
  };
}
