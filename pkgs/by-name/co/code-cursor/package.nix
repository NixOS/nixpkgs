{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  makeWrapper,
  undmg,

}:

let
  pname = "cursor";
  version = "0.45.8";

  inherit (stdenvNoCC) hostPlatform;

  sources = {
    x86_64-linux = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/cursor-0.45.8-build-250201b44xw1x2k-x86_64.AppImage";
      hash = "sha256-H+9cisa1LWJleqzwaB0WIzJpioYZyfLghelcZthCOvg=";
    };
    aarch64-linux = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/cursor-0.45.8-build-250201b44xw1x2k-arm64.AppImage";
      hash = "sha256-GgPt9SvuCA9Hxm7nxm7mz0AvPKaLWCkYXO225taXnLA=";
    };
    x86_64-darwin = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/Cursor%200.45.8%20-%20Build%20250201b44xw1x2k-x64.dmg";
      hash = "sha256-UqwzgxBSZR0itCknKzBClEX3w9aFKFhGIiVUQNYDVEM=";
    };
    aarch64-darwin = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/Cursor%200.45.8%20-%20Build%20250201b44xw1x2k-arm64.dmg";
      hash = "sha256-AUW19xJFsrDGSUNE/bwkC2aN2QyaS+JKCjuxx//kbiI=";
    };
  };

  source = sources.${hostPlatform.system};

  # Linux -- build from AppImage
  appimageContents = appimageTools.extractType2 {
    inherit version pname;
    src = source;
  };

  wrappedAppimage = appimageTools.wrapType2 {
    inherit version pname;
    src = source;
  };

in
stdenvNoCC.mkDerivation rec {
  inherit pname version;

  src = if hostPlatform.isLinux then wrappedAppimage else source;

  nativeBuildInputs =
    lib.optionals hostPlatform.isLinux [ makeWrapper ]
    ++ lib.optionals hostPlatform.isDarwin [ undmg ];

  sourceRoot = lib.optionalString hostPlatform.isDarwin ".";

  # Don't break code signing
  dontUpdateAutotoolsGnuConfigScripts = hostPlatform.isDarwin;
  dontConfigure = hostPlatform.isDarwin;
  dontFixup = hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/

    ${lib.optionalString hostPlatform.isLinux ''
      cp -r bin $out/bin
      mkdir -p $out/share/cursor
      cp -a ${appimageContents}/locales $out/share/cursor
      cp -a ${appimageContents}/resources $out/share/cursor
      cp -a ${appimageContents}/usr/share/icons $out/share/
      install -Dm 644 ${appimageContents}/cursor.desktop -t $out/share/applications/

      substituteInPlace $out/share/applications/cursor.desktop --replace-fail "AppRun" "cursor"

      wrapProgram $out/bin/cursor \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}} --no-update"
    ''}

    ${lib.optionalString hostPlatform.isDarwin ''
      APP_DIR="$out/Applications"
      CURSOR_APP="$APP_DIR/Cursor.app"
      mkdir -p "$APP_DIR"
      cp -Rp Cursor.app "$APP_DIR"
      mkdir -p "$out/bin"
      cat << EOF > "$out/bin/cursor"
      #!${stdenvNoCC.shell}
      open -na "$CURSOR_APP" --args "\$@"
      EOF
      chmod +x "$out/bin/cursor"
    ''}

    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = ./update.sh;
  };

  meta = {
    description = "AI-powered code editor built on vscode";
    homepage = "https://cursor.com";
    changelog = "https://cursor.com/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      sarahec
      aspauldingcode
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "cursor";
  };

}
