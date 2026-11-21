{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  jdk8,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pmd";
  version = "7.29.0";

  src = fetchurl {
    url = "https://github.com/pmd/pmd/releases/download/pmd_releases/${finalAttrs.version}/pmd-dist-${finalAttrs.version}-bin.zip";
    hash = "sha256-0nF3wYW4N/pX8JfkgtElNGiqA1N5xesmcfoKJ5EJsXk=";
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 bin/pmd $out/bin/pmd
    cp -r lib conf $out/
    wrapProgram $out/bin/pmd --suffix PATH : ${jdk8.jre}/bin

    runHook postInstall
  '';

  meta = {
    description = "Extensible cross-language static code analyzer";
    homepage = "https://pmd.github.io/";
    changelog = "https://docs.pmd-code.org/pmd-doc-${finalAttrs.version}/pmd_release_notes.html";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      bsdOriginal
      asl20
    ];
  };
})
