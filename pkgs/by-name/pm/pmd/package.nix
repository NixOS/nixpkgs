{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  jdk17,
}:

let
  jdk = jdk17.override { enableJavaFX = true; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pmd";
  version = "7.25.0";

  src = fetchurl {
    url = "https://github.com/pmd/pmd/releases/download/pmd_releases%2F${finalAttrs.version}/pmd-dist-${finalAttrs.version}-bin.zip";
    hash = "sha256-H86zAF6/1YDMmvpSQuB990gm7t6yJfI59QMIOEXXf8I=";
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/pmd $out/libexec/pmd
    install -Dm644 lib/*.jar -t $out/lib/pmd
    cp -r conf $out/lib/pmd-conf

    wrapProgram $out/libexec/pmd \
        --prefix PATH : ${jdk}/bin \
        --set LIB_DIR $out/lib/pmd \
        --set CONF_DIR $out/lib/pmd-conf

    makeWrapper $out/libexec/pmd $out/bin/pmd --argv0 pmd
    makeWrapper $out/libexec/pmd $out/bin/cpd --argv0 cpd --add-flags cpd
    makeWrapper $out/libexec/pmd $out/bin/cpdgui --argv0 cpdgui --add-flags cpd-gui
    makeWrapper $out/libexec/pmd $out/bin/designer --argv0 designer --add-flags designer
    makeWrapper $out/libexec/pmd $out/bin/ast-dump --argv0 ast-dump --add-flags ast-dump

    runHook postInstall
  '';

  meta = {
    description = "Extensible cross-language static code analyzer";
    homepage = "https://pmd.github.io/";
    changelog = "https://pmd.github.io/pmd-${finalAttrs.version}/pmd_release_notes.html";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      bsdOriginal
      asl20
    ];
  };
})
