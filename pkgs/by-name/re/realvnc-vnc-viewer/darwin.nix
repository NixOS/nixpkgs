{
  stdenvNoCC,
  fetchurl,
  gzip,
  xar,
  cpio,
  pname,
  version,
  meta,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version meta;

  src = fetchurl rec {
    name = "RealVNC-Connect-Viewer-${finalAttrs.version}-MacOSX-universal.pkg";
    url = "https://downloads.realvnc.com/download/file/realvnc-connect-viewer/${name}";
    hash = "sha256:0rpgvifx3r1acb2ny40k80c1ayxhi14wnnd88yw707qcqrg0ziz9";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [
    gzip
    xar
    cpio
  ];

  unpackPhase = ''
    runHook preUnpack

    xar -xf $src
    gunzip -dc RealVNC-Connect-Viewer-${finalAttrs.version}-MacOSX-universal-comp.pkg/Payload > decompressed.out
    cat decompressed.out | cpio -it | grep -v '/._' > file-list-no-resource-forks.txt
    cat decompressed.out | cpio -i -E file-list-no-resource-forks.txt

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Applications/*.app $out/Applications

    runHook postInstall
  '';
})
