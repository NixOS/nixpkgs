{ lib
, stdenvNoCC
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
      sha256 = "1i9mly54qqxhiy6z9p0q8px3n1rc014vdxjzsmn3mx25q11gd845";
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
