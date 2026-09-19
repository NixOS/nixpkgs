{
  lib,
  fetchFromGitHub,
  jre_headless,
  makeWrapper,
  maven,
  jdk11,
}:
maven.buildMavenPackage (finalAttrs: {
  pname = "cfr";
  version = "0.152";

  src = fetchFromGitHub {
    owner = "leibnitz27";
    repo = "cfr";
    tag = finalAttrs.version;
    hash = "sha256-bT/qlMD2aNhW9i4DEYymSbfKqtE/m1m6h5UkbFIyj4E=";
  };

  # Otherwise fails, because the .git folder is stripped
  mvnParameters = "-Dmaven.gitcommitid.skip=true";

  mvnJdk = jdk11;

  mvnHash = "sha256-JvmOCMmZJIeIaYkGvhwRPGK/Q1LCHSVJFRF7WIBJFDg=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/cfr
    install -Dm644 target/cfr-${finalAttrs.version}.jar $out/share/cfr

    makeWrapper ${lib.getExe jre_headless} $out/bin/cfr \
      --add-flags "-jar $out/share/cfr/cfr-${finalAttrs.version}.jar"

    runHook postInstall
  '';

  meta = {
    description = "Another java decompiler";
    longDescription = ''
      CFR will decompile modern Java features - Java 8 lambdas (pre and post
      Java beta 103 changes), Java 7 String switches etc, but is written
      entirely in Java 6.
    '';
    homepage = "https://github.com/leibnitz27/cfr";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ letgamer ];
    mainProgram = "cfr";
  };
})
