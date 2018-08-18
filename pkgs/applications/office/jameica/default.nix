{ stdenv, fetchFromGitHub, makeDesktopItem, makeWrapper, ant, jdk, jre, xmlstarlet, gtk2, glib, xorg }:

let
  _version = "2.8.1";
  _build = "449";
  version = "${_version}-${_build}";
  name = "jameica-${version}";

  swtSystem = if stdenv.system == "i686-linux" then "linux"
  else if stdenv.system == "x86_64-linux" then "linux64"
  else throw "Unsupported system: ${stdenv.system}";

  launcher = ''
    #!${stdenv.shell}
    exec ${jre}/bin/java -Xmx512m de.willuhn.jameica.Main "$@"
  '';

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

  nativeBuildInputs = [ ant jdk makeWrapper xmlstarlet ];
  buildInputs = [ gtk2 glib xorg.libXtst ];

  src = fetchFromGitHub {
    owner = "willuhn";
    repo = "jameica";
    rev = "V_${builtins.replaceStrings ["."] ["_"] _version}_BUILD_${_build}";
    sha256 = "1w25lxjskn1yxllbv0vgvcc9f9xvgv9430dm4b59ia9baf98syd2";
  };

  # there is also a build.gradle, but it only seems to be used to vendor 3rd party libraries
  # and is not able to build the application itself
  buildPhase = ''
    (cd build; ant init compile jar)
  '';

  # jameica itself loads ./plugin.xml to determine it's version.
  # Unfortunately, the version attribute there seems to be wrong,
  # so it thinks it's older than it really is,
  # and refuses to load plugins destined for its version.
  # Set version manually to workaround that.
  postPatch = ''
    xml ed -u '/system/@version' -v '${version}' plugin.xml > plugin.xml.new
    mv plugin.xml.new plugin.xml
  '';

  installPhase = ''
    mkdir -p $out/libexec $out/lib $out/bin $out/share/applications

    # copy libraries except SWT
    cp $(find lib -type f -iname '*.jar' | grep -ve 'swt/.*/swt.jar') $out/lib/
    # copy platform-specific SWT
    cp lib/swt/${swtSystem}/swt.jar $out/lib

    install -Dm644 releases/${_version}-*/jameica/jameica.jar $out/libexec/
    install -Dm644 plugin.xml $out/libexec/
    install -Dm644 build/jameica-icon.png $out/share/pixmaps/jameica.png
    cp ${desktopItem}/share/applications/* $out/share/applications/

    echo "${launcher}" > $out/bin/jameica
    chmod +x $out/bin/jameica
    wrapProgram $out/bin/jameica --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath buildInputs} \
                                 --set CLASSPATH "$out/libexec/jameica.jar:$out/lib/*" \
                                 --run "cd $out/libexec"
                                 # jameica expects its working dir set to the "program directory"
  '';

  meta = with stdenv.lib; {
    homepage = https://www.willuhn.de/products/jameica/;
    description = "Free Runtime Environment for Java Applications.";
    longDescription = ''
      Runtime Environment for plugins like Hibiscus (HBCI Online Banking),
      SynTAX (accounting) and JVerein (club management).
    '';
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ flokli ];
  };
}
