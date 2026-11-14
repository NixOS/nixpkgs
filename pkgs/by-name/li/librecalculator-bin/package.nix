{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  wrapGAppsHook3,
  gtk3,
  glib,
  cairo,
  pango,
  gdk-pixbuf,
  dbus,
  libsoup_3,
  webkitgtk_4_1,
  libayatana-appindicator,
  xdotool,
  libxkbcommon,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librecalculator-bin";
  version = "0.1.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/tonyzedginidze/librecalculator/releases/download/v${finalAttrs.version}/Libre.Calculator_${finalAttrs.version}_amd64.deb";
    sha256 = "f4cebcae62a68de1a0fc062a7d9e2abbb3b14a096ca731ceed79018e27f73d24";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    glib
    cairo
    pango
    gdk-pixbuf
    dbus
    libsoup_3
    webkitgtk_4_1
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x "$src" .
    runHook postUnpack
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -r usr/bin usr/share "$out/"
    mv "$out/share/applications/Libre Calculator.desktop" "$out/share/applications/librecalculator.desktop"
    substituteInPlace "$out/share/applications/librecalculator.desktop" \
      --replace-fail "Exec=libre-calculator-desktop" "Exec=$out/bin/libre-calculator-desktop"
    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libayatana-appindicator
          xdotool
          libxkbcommon
          libx11
        ]
      }"
    )
  '';

  meta = {
    description = "Calculators with worked steps, formulas and visual explanations";
    homepage = "https://librecalculator.com";
    changelog = "https://github.com/tonyzedginidze/librecalculator/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ tonyzedginidze ];
    mainProgram = "libre-calculator-desktop";
    platforms = [ "x86_64-linux" ];
  };
})
