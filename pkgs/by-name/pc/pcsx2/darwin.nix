{
  stdenvNoCC,
  fetchurl,
  pname,
  version,
  meta,
  makeWrapper
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version meta;

  src = fetchurl {
    url = "https://github.com/PCSX2/pcsx2/releases/download/v${version}/pcsx2-v${version}-macos-Qt.tar.xz";
    hash = "sha256-QdYV63lrAwYSDhUOy4nB8qL5LfZkrg/EYHtY2smtZuk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,Applications}
    cp -r "PCSX2-v${finalAttrs.version}.app" $out/Applications/PCSX2.app
    makeWrapper $out/Applications/PCSX2.app/Contents/MacOS/PCSX2 $out/bin/pcsx2-qt
    runHook postInstall
  '';
})
