{ stdenvNoCC
, fetchurl
, undmg
, pname
, version
, meta
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version meta;

  src = fetchurl rec {
      name = "VNC-Viewer-${finalAttrs.version}-MacOSX-universal.dmg";
      url = "https://downloads.realvnc.com/download/file/viewer.files/${name}";
      hash = "sha256-haD2QsBF9Dps1V/2tkkALAc7+kUY3PSNj7BjTIqnNcU=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';
})
