{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  undmg,
  gtk3,
  gdk-pixbuf,
  cairo,
  glib,
  webkitgtk_4_1,
  libsoup_3,
}:

let
  version = "1.1.12";

  sources = {
    x86_64-linux = {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-desktop-linux-amd64.deb";
      hash = "sha256-ukigCzeRLPHAgmwHrTnndrEXhFFcpgzquevOwI52rZI=";
    };
    aarch64-linux = {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-desktop-linux-arm64.deb";
      hash = "sha256-4PpkLqCQcPzV+ixClRBDZxbfUFmbVp+RX+yLxBgs8M4=";
    };
    x86_64-darwin = {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-desktop-darwin-x64.dmg";
      hash = "sha256-UcgjCYPQHAkZIitxX0EjNjFoLdi10WggxzYcoRb9HFc=";
    };
    aarch64-darwin = {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-desktop-darwin-aarch64.dmg";
      hash = "sha256-eXFYh40/daFIr91v8wcI3/1ZJ0IIin+/4bxXZ+beWi8=";
    };
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "opencode-desktop";
  inherit version;

  src = fetchurl sources.${stdenv.hostPlatform.system};

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      dpkg
      autoPatchelfHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      undmg
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gtk3
    gdk-pixbuf
    cairo
    glib
    webkitgtk_4_1
    libsoup_3
    stdenv.cc.cc.lib # for libgcc_s
  ];

  unpackPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        undmg $src
      ''
    else
      ''
        dpkg-deb -x $src .
      '';

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall
        mkdir -p $out/Applications
        cp -r *.app $out/Applications/
        runHook postInstall
      ''
    else
      ''
        runHook preInstall
        mkdir -p $out
        cp -r usr/* $out/
        runHook postInstall
      '';

  meta = {
    description = "Desktop interface for the open source coding agent";
    homepage = "https://opencode.ai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anish ];
    platforms = lib.attrNames sources;
    mainProgram = "OpenCode";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
