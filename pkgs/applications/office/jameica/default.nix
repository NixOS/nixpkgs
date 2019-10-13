{ stdenv, fetchFromGitHub, makeDesktopItem, makeWrapper, ant, jdk, jre, gtk2, glib, xorg, Cocoa }:

let
  _version = "2.8.4";
  _build = "453";
  version = "${_version}-${_build}";
  name = "jameica-${version}";

  swtSystem = if stdenv.hostPlatform.system == "i686-linux" then "linux"
  else if stdenv.hostPlatform.system == "x86_64-linux" then "linux64"
  else if stdenv.hostPlatform.system == "x86_64-darwin" then "macos64"
  else throw "Unsupported system: ${stdenv.hostPlatform.system}";

  desktopItem = makeDesktopItem {
    name = "jameica";
    exec = "jameica";
    comment = "Free Runtime Environment for Java Applications.";
    desktopName = "Jameica";
    genericName = "Jameica";
    categories = "Application;Office;";
  };
in
stdenv.mkDerivation rec {
  inherit name version;

  nativeBuildInputs = [ ant jdk makeWrapper ];
  buildInputs = stdenv.lib.optionals stdenv.isLinux [ gtk2 glib xorg.libXtst ]
                ++ stdenv.lib.optional stdenv.isDarwin Cocoa;

  src = fetchFromGitHub {
    owner = "willuhn";
    repo = "jameica";
    rev = "V_${builtins.replaceStrings ["."] ["_"] _version}_BUILD_${_build}";
    sha256 = "1imm3wpdrgh2sr2wh9vgaf2mp1ixs845vgzk5ib82mak7lg9m1zl";
  };

  # there is also a build.gradle, but it only seems to be used to vendor 3rd party libraries
  # and is not able to build the application itself
  buildPhase = ''
    (cd build; ant -Dsystem.version=${version} init compile jar)
  '';

  installPhase = ''
    mkdir -p $out/libexec $out/lib $out/bin $out/share/{applications,${name},java}/

    # copy libraries except SWT
    cp $(find lib -type f -iname '*.jar' | grep -ve 'swt/.*/swt.jar') $out/share/${name}/
    # copy platform-specific SWT
    cp lib/swt/${swtSystem}/swt.jar $out/share/${name}/

    install -Dm644 releases/${_version}-*/jameica/jameica.jar $out/share/java/
    install -Dm644 plugin.xml $out/share/java/
    install -Dm644 build/jameica-icon.png $out/share/pixmaps/jameica.png
    cp ${desktopItem}/share/applications/* $out/share/applications/

    makeWrapper ${jre}/bin/java $out/bin/jameica \
      --add-flags "-cp $out/share/java/jameica.jar:$out/share/${name}/* ${
        stdenv.lib.optionalString stdenv.isDarwin ''-Xdock:name="Jameica" -XstartOnFirstThread''
      } de.willuhn.jameica.Main" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath buildInputs} \
      --run "cd $out/share/java/"
  '';

  meta = with stdenv.lib; {
    homepage = https://www.willuhn.de/products/jameica/;
    description = "Free Runtime Environment for Java Applications";
    longDescription = ''
      Runtime Environment for plugins like Hibiscus (HBCI Online Banking),
      SynTAX (accounting) and JVerein (club management).
    '';
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ flokli ];
  };
}
