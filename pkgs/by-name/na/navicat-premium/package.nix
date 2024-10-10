{
  fetchurl,
  appimageTools,
  lib,
  libGL,
  glib,
  glibc,
  pango,
  harfbuzz,
  fontconfig,
  libX11,
  freetype,
  e2fsprogs,
  expat,
  p11-kit,
  libxcb,
  libgpg-error,
  stdenv,
  cjson,
  libxcrypt-legacy,
  curl,
  makeWrapper,
  autoPatchelfHook,
  libxkbcommon,
  libselinux,
  language ? "en",
  isLite ? false,
}:
assert lib.elem language [
  "en"
  "cs"
];
assert lib.isBool isLite;
let
  pname = if isLite then "navicat-premium-lite" else "navicat-premium";
  version = "17.1.1";
  srcHashes = {
    en = {
      lite = "sha256-etKXXttd+bSQTyOyzbDx1mXhBH6xqQ1e+aqZIGgKcHs=";
      full = "sha256-A+JSvzt2E/zq5rajjmRlNFkxUGyu33fAkkBYkTMHcYM=";
    };
    cs = {
      lite = "sha256-CFNJQXf8vX1NDY81n2/P2cs/N3ZcWFJVjv9yY7yZyJQ=";
      full = "sha256-TGSnn6fa8qLLMltOAdmZvPgdfM1Ut9eCsuV4G/uZjDw=";
    };
  };
  src = fetchurl {
    url = "https://dn.navicat.com/download/navicat17-premium-${
      if isLite then "lite-" else ""
    }${language}-x86_64.AppImage";
    hash = srcHashes.${language}.${if isLite then "lite" else "full"};
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libgpg-error
    libxcb
    p11-kit
    expat
    e2fsprogs
    freetype
    libX11
    fontconfig
    harfbuzz
    pango
    glibc
    glib
    libGL
    cjson
    curl
    libxcrypt-legacy
    libxkbcommon
    libselinux
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    cp -a ${appimageContents}/usr $out/
    chmod -R u+rwX,go+rX,go-w $out
    mkdir -p $out/usr
    ln -s $out/lib $out/usr/lib

    runHook postInstall
  '';

  preFixup = ''
    wrapProgram $out/bin/navicat \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          glib
          glibc
          pango
          harfbuzz
          fontconfig
          libX11
          freetype
          e2fsprogs
          expat
          p11-kit
          libxcb
          libgpg-error
          libxkbcommon
          libselinux
        ]
      }:$out/lib" \
      --set QT_PLUGIN_PATH "$out/plugins" \
      --set QT_QPA_PLATFORM xcb \
      --set QT_STYLE_OVERRIDE Fusion \
      --chdir "$out"
  '';

  meta = {
    homepage =
      if isLite then
        "https://www.navicat.com/products/navicat-premium-lite"
      else
        "https://www.navicat.com/products/navicat-premium";
    description =
      if isLite then
        "Navicat Premium Lite is a compact version of Navicat, packed with the core features needed for users who primarily need to perform basic database operations"
      else
        "Navicat Premium is a database development tool that allows you to simultaneously connect to MySQL, PostgreSQL, MongoDB, MariaDB, SQL Server, Oracle, SQLite, and Redis databases from a single application";
    mainProgram = "navicat";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ aucub ];
    platforms = with lib.platforms; linux ++ darwin;
    broken = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64);
  };
}
