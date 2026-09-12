{
  pname,
  version,
  meta,

  lib,
  fetchurl,
  stdenvNoCC,

  # nativeBuildInputs
  makeBinaryWrapper,
  undmg,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/localsend/localsend/releases/download/v${finalAttrs.version}/LocalSend-${finalAttrs.version}.dmg";
    hash = "sha256-k6uITCcDoPq9cmEQl7JhbA3vhsQlbOoq3XoP823Xazo=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    undmg
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r LocalSend.app $out/Applications

    makeWrapper $out/Applications/LocalSend.app/Contents/MacOS/LocalSend $out/bin/localsend

    runHook postInstall
  '';

  meta = meta // {
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "localsend";
    platforms = [ "aarch64-darwin" ];
  };
})
