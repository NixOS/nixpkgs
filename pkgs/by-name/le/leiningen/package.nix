{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  coreutils,
  jdk,
  rlwrap,
  gnupg,
  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "leiningen";
  version = "2.13.1";

  src = fetchurl {
    url = "https://codeberg.org/leiningen/leiningen/raw/tag/${finalAttrs.version}/bin/lein-pkg";
    hash = "sha256-2r5tMf4SwhxMOP19VjnfPh/205ZQZFLKGaRyL93R6FI=";
  };

  jarsrc = fetchurl {
    url = "https://codeberg.org/leiningen/leiningen/releases/download/${finalAttrs.version}/leiningen-${finalAttrs.version}-standalone.jar";
    hash = "sha256-Lkw2y673F9D6WJofleTFJqHLbDW0jckubbsw1vhZW1w=";
  };

  env.JARNAME = "leiningen-${finalAttrs.version}-standalone.jar";

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ jdk ];

  # the jar is not in share/java, because it's a standalone jar and should
  # never be picked up by set-java-classpath.sh

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -v $src $out/bin/lein
    cp -v $jarsrc $out/share/$JARNAME

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    chmod +x $out/bin/lein
    patchShebangs $out/bin/lein
    substituteInPlace $out/bin/lein \
      --replace-fail 'LEIN_JAR=/usr/share/java/leiningen-$LEIN_VERSION-standalone.jar' "LEIN_JAR=$out/share/$JARNAME"
    wrapProgram $out/bin/lein \
      --prefix PATH ":" "${
        lib.makeBinPath [
          rlwrap
          coreutils
        ]
      }" \
      --set LEIN_GPG ${gnupg}/bin/gpg \
      --set JAVA_CMD ${jdk}/bin/java

    runHook postFixup
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://leiningen.org/";
    description = "Project automation for Clojure";
    changelog = "https://codeberg.org/leiningen/leiningen/src/tag/${finalAttrs.version}/NEWS.md";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    platforms = jdk.meta.platforms;
    maintainers = with lib.maintainers; [ kamadorueda ];
    mainProgram = "lein";
  };
})
