{ lib, stdenv, fetchFromGitHub, makeDesktopItem, makeWrapper, wrapGAppsHook, ant, jdk, jre, gtk2, glib, xorg, Cocoa }:

let
  _version = "2.10.2";
  _build = "484";
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

  nativeBuildInputs = [ ant jdk wrapGAppsHook makeWrapper ];
  buildInputs = lib.optionals stdenv.isLinux [ gtk2 glib xorg.libXtst ]
    ++ lib.optional stdenv.isDarwin Cocoa;

  src = fetchFromGitHub {
    owner = "willuhn";
    repo = "jameica";
    rev = "V_${builtins.replaceStrings ["."] ["_"] _version}_BUILD_${_build}";
    sha256 = "1x9sybknzsfxp9z0pvw9dx80732ynyap57y03p7xwwjbcrnjla57";
  };

  dontWrapGApps = true;

  # there is also a build.gradle, but it only seems to be used to vendor 3rd party libraries
  # and is not able to build the application itself
  buildPhase = ''
    (cd build; ant -Dsystem.version=${version} init compile jar)
  '';

  installPhase = ''
    mkdir -p $out/libexec $out/lib $out/bin $out/share/{applications,jameica-${version},java}/

    # copy libraries except SWT
    cp $(find lib -type f -iname '*.jar' | grep -ve 'swt/.*/swt.jar') $out/share/jameica-${version}/
    # copy platform-specific SWT
    cp lib/swt/${swtSystem}/swt.jar $out/share/jameica-${version}/

    install -Dm644 releases/${_version}-*/jameica/jameica.jar $out/share/java/
    install -Dm644 plugin.xml $out/share/java/
    install -Dm644 build/jameica-icon.png $out/share/pixmaps/jameica.png
    cp ${desktopItem}/share/applications/* $out/share/applications/
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
  };
}
