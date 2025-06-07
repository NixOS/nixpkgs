{
  stdenv,
  lib,
  fetchurl,
  xz,
  _7zz,
}:

let
  pname = "calibre-bin";
  version = "7.20.0";

  sources = {
    x86_64-linux = {
      url = "https://github.com/kovidgoyal/calibre/releases/download/v${version}/calibre-${version}-x86_64.txz";
      hash = "sha256-yw+Uly6uI+eiWZjFHdXJr4bP41EnW8JOY11CLc9Yb78=";
    };
    aarch64-linux = {
      url = "https://github.com/kovidgoyal/calibre/releases/download/v${version}/calibre-${version}-arm64.txz";
      hash = "sha256-hyW8BIy23nRxckTdw8x+Piqy3/aU/lI9/k/3BsLgAKk=";
    };
    universal-darwin = {
      url = "https://github.com/kovidgoyal/calibre/releases/download/v${version}/calibre-${version}.dmg";
      hash = "sha256-kEbxO2K9Fo7CplxBn0IxPIwh88xKTY/udiLjC1Z4JVw=";
    };
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl (
    sources.${if stdenv.hostPlatform.isDarwin then "universal-darwin" else stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
  );

  sourceRoot = ".";
  nativeBuildInputs = lib.optionals stdenv.isLinux [ xz ] ++ lib.optionals stdenv.isDarwin [ _7zz ];
  # the extra flag is required for the 7zz binary to extract properly
  unpackCmd = lib.strings.optionalString stdenv.isDarwin ''
    7zz x -snld $curSrc
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase =
    lib.strings.optionalString stdenv.isDarwin ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r Calibre.app $out/Applications

      runHook postInstall
    ''
    + lib.strings.optionalString stdenv.isLinux ''
      runHook preInstall

      mkdir -p $out
      cp -r . $out/

      runHook postInstall
    '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "E-book manager";
    longDescription = ''
      Calibre is a free and open source e-book library management application
      developed by users of e-books for users of e-books.
    '';
    homepage = "https://calibre-ebook.com";
    downloadPage = "https://calibre-ebook.com/download";
    changelog = "https://calibre-ebook.com/whats-new";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fbettag ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
