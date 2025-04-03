{
  lib,
  stdenv,
  makeBinaryWrapper,
  zulu,
  ant,
  darwin,

  pname,
  version,
  src,
  meta,
  patches,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    src
    meta
    patches
    ;

  nativeBuildInputs = [
    darwin.autoSignDarwinBinariesHook
    makeBinaryWrapper
    ant
  ];
  buildInputs = [
    zulu
  ];

  buildPhase = ''
    runHook preBuild

    ant macosxBundle -DjavaHome_macosx_arm64=${zulu.home}/zulu-${lib.versions.major zulu.version}.jdk/Contents/Home

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv "install/macosx/SweetHome3D-${finalAttrs.version}/Sweet Home 3D.app" $out/Applications
    makeWrapper "$out/Applications/Sweet Home 3D.app/Contents/MacOS/SweetHome3D" $out/bin/sweethome3d

    runHook postInstall
  '';

  dontStrip = true;
})
