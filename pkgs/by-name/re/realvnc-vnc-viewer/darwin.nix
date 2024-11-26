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
      hash = "sha256-SiBlw9ihKDLDWBPUxn3cfM0jbUaWDxQ9JDaeDNczQ7c=";
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
