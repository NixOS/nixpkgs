{
  addDriverRunpath,
  buildFHSEnv,
  copyDesktopItems,
  fetchurl,
  lib,
  makeDesktopItem,
  makeWrapper,
  stdenv,
  writeScript,
  cairo,
  fontconfig,
  freetype,
  gdk-pixbuf,
  git,
  glib,
  gnused,
  gobject-introspection,
  gtk3,
  jdk21,
  libGL,
  libGLU,
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libXxf86vm,
  openal,
  pango,
  zlib,
  uiScale ? "1.0",
}:
let
  pname = "defold";
  version = "1.10.1";

  defold = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/defold/defold/releases/download/${version}/Defold-x86_64-linux.tar.gz";
      hash = "sha256-z6jlSXiQKO+QWPgtRmP7v3GTuI3+uCSbm7Y0GkqjpUA=";
    };

    dontBuild = true;
    dontConfigure = true;
    dontStrip = true;

    nativeBuildInputs = [
      addDriverRunpath
      copyDesktopItems
      gnused
      (jdk21.override { enableJavaFX = true; })
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall
      # Install Defold assets, but not the bundled JDK
      install -m 755 -D Defold $out/share/defold/Defold
      install -m 644 -D config $out/share/defold/config
      install -m 444 -D logo_blue.png $out/share/defold/logo_blue.png
      install -m 444 -D logo_blue.png \
          $out/share/icons/hicolor/512x512/apps/defold.png
      mkdir -p $out/share/defold/packages
      cp -a packages/defold-*.jar $out/share/defold/packages/
      runHook postInstall
    '';

    postFixup = ''
      # Devendor bundled JDK; it segfaults on NixOS
      JDK_VER=$(sed -n 's/.*\/\(jdk-[^/]*\).*/\1/p' $out/share/defold/config)
      ln -s ${jdk21} $out/share/defold/packages/${jdk21.name}
      sed -i "s|packages/$JDK_VER|packages/${jdk21.name}|" $out/share/defold/config
      # Disable editor updates; Nix will handle updates
      sed -i 's/\(channel = \).*/\1/' $out/share/defold/config
      # Scale the UI
      sed -i "s|^linux =|linux = -Dglass.gtk.uiScale=${uiScale}|" $out/share/defold/config
      addDriverRunpath $out/share/defold/Defold
      makeWrapper "$out/share/defold/Defold" "$out/bin/Defold"
    '';

    desktopItems = [
      (makeDesktopItem rec {
        name = "defold-editor";
        desktopName = "Defold";
        comment = "An out of the box, turn-key solution for multi-platform game development";
        keywords = [
          "Game"
          "Development"
        ];
        exec = "defold";
        terminal = false;
        type = "Application";
        icon = "defold";
        categories = [
          "Development"
          "IDE"
        ];
        startupNotify = true;
        startupWMClass = "com.defold.editor.Start";
      })
    ];
  };
in
buildFHSEnv {
  name = pname;
  targetPkgs = pkgs: [
    cairo
    defold
    fontconfig
    freetype
    gdk-pixbuf
    git
    glib
    gobject-introspection
    gtk3
    libGL
    libGLU
    libX11
    libXcursor
    libXext
    libXi
    libXrandr
    libXrender
    libXtst
    libXxf86vm
    openal
    pango
    zlib
  ];
  runScript = "Defold";

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/512x512/apps
    ln -s ${defold}/share/applications/*.desktop \
      $out/share/applications/
    ln -s ${defold}/share/icons/hicolor/512x512/apps/defold.png \
      $out/share/icons/hicolor/512x512/apps/defold.png
  '';

  passthru = {
    updateScript = writeScript "update-defold" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq nix-update
      version=$(curl -s https://d.defold.com/editor-alpha/info.json | jq -r .version)
      nix-update defold --version "$version"
    '';
  };

  meta = {
    description = "The game engine for high-performance cross-platform games";
    homepage = "https://www.defold.com";
    license = lib.licenses.free;
    longDescription = ''
      Defold is a completely free to use game engine for development of desktop, mobile, console and web games.
    '';
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ flexiondotorg ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "defold";
  };
}
