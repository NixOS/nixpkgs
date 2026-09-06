{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  undmg,
  autoPatchelfHook,
  wrapGAppsHook3,
  alsa-lib,
  gtk3,
  pango,
  harfbuzz,
  gdk-pixbuf,
  cairo,
  glib,
  dbus,
  webkitgtk_4_1,
  atk,
  libsoup_3,
  openssl_3,
  libayatana-appindicator,
}:

let
  pname = "github-copilot-app";
  version = "1.1.14";

  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/github/app/releases/download/v${version}/GitHub-Copilot-linux-x64.deb";
      hash = "sha256-0qwltVNjJ4x+S1BTZnbagn4zYjEjMX3MXn6Vb4fgAtA=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/github/app/releases/download/v${version}/GitHub-Copilot-linux-arm64.deb";
      hash = "sha256-zWDArkFPGjKH9QwPSeYQ6te/tUnnSqPbd216542FA64=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/github/app/releases/download/v${version}/GitHub-Copilot-darwin-arm64.dmg";
      hash = "sha256-avOISG0qdkLdmmsXA3rAfXmOnCqeUsaBCGzfRkVpi9Q=";
    };
  };

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      dpkg
      autoPatchelfHook
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      undmg
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    gtk3
    pango
    harfbuzz
    gdk-pixbuf
    cairo
    glib
    dbus
    webkitgtk_4_1
    atk
    libsoup_3
    openssl_3
    libayatana-appindicator
    stdenv.cc.cc.lib
  ];

  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    libayatana-appindicator
  ];

  dontStrip = true;
  strictDeps = true;
  __structuredAttrs = true;

  unpackCmd = if stdenv.hostPlatform.isDarwin then "undmg $curSrc" else "dpkg-deb -x $curSrc .";
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
  ''
  + (
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
        cp -r *.app $out/Applications/

        mkdir -p $out/bin
        ln -s "$out/Applications/"*.app/Contents/MacOS/git-credential-copilot "$out"/bin/git-credential-copilot
        ln -s "$out/Applications/"*.app/Contents/MacOS/github "$out"/bin/github-copilot-app
      ''
    else
      ''
        mkdir -p $out/bin $out/share $out/lib

        cp -r usr/share/* $out/share/
        cp -r usr/lib/* $out/lib/

        # Rename the main executable from github to github-copilot-app to avoid conflicts
        mv usr/bin/github $out/bin/github-copilot-app
        cp usr/bin/git-credential-copilot $out/bin/

        # Update desktop file to use the new executable name
        substituteInPlace $out/share/applications/*.desktop \
          --replace-fail "Exec=github" "Exec=github-copilot-app"
      ''
  )
  + ''
    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Agent-native desktop experience for GitHub repositories";
    homepage = "https://github.com/github/app";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ rachalaraj ];
    mainProgram = "github-copilot-app";
    platforms = lib.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
