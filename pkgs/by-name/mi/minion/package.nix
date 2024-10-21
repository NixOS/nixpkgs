{
  stdenvNoCC,
  lib,
  fetchzip,
  openjdk22,
  makeDesktopItem,
  javaPackages,
  gsettings-desktop-schemas,
  gtk3,
}:

let
  openjfx = javaPackages.openjfx22.override { withWebKit = true; };
  jdk = openjdk22.override (
    prev:
    prev
    // {
      enableJavaFX = true;
      inherit openjfx;
    }
  );
in
stdenvNoCC.mkDerivation rec {
  version = "3.0.12";
  pname = "minion";

  src = fetchzip {
    url = "https://cdn.mmoui.com/minion/v3/Minion${version}-java.zip";
    hash = "sha256-KjSj3TBMY3y5kgIywtIDeil0L17dau/Rb2HuXAulSO8=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib/${pname}"
    cp ./Minion-jfx.jar "$out/lib/${pname}/Minion-jfx.jar"
    cp -r ./lib "$out/lib/${pname}/lib"

    cat > "$out/bin/${pname}" << EOF
    #!${stdenvNoCC.shell}
    CLASSPATH="$out/lib"
    XDG_DATA_DIRS="${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:XDG_DATA_DIRS"
    exec ${lib.getExe jdk} \
    --add-exports=javafx.graphics/com.sun.javafx.css=ALL-UNNAMED \
    --add-exports=javafx.graphics/javafx.scene.image=ALL-UNNAMED \
    --add-opens=javafx.graphics/javafx.scene.image=ALL-UNNAMED \
    --add-opens=java.base/java.lang=ALL-UNNAMED \
    -cp "$CLASSPATH ./lib" -jar "$out/lib/${pname}/Minion-jfx.jar" "\$@"
    EOF

    chmod a+x "$out/bin/${pname}"

  '';

  desktopItems = [
    (makeDesktopItem {
      name = "minion";
      exec = "minion";
      comment = "MMO Addon manager for Elder Scrolls Online and World of Warcraft";
      desktopName = "Minion";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "Addon manager for World of Warcraft and The Elder Scrolls Online";
    homepage = "https://minion.mmoui.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    mainProgram = minion;
    maintainers = with lib.maintainers; [ patrickdag ];
  };
}
