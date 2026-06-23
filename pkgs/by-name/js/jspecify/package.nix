{
  lib,
  stdenv,
  fetchFromGitHub,
  writeShellScript,
  nix-update,
  gradle,
  jdk21,
  jre_minimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jspecify";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jspecify";
    repo = "jspecify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WgVRaGm9lYhMeMM6QWUezXtUsXkaK/iPt1gj2koWNu8=";
  };

  nativeBuildInputs = [
    gradle
    jdk21
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # JSpecify's build.gradle reads JAVA_VERSION (defaults to 11). Pin it so Gradle's
  # toolchain machinery resolves to the JDK we provide instead of trying
  # to auto-download one.
  env.JAVA_VERSION = lib.versions.major jdk21.version;

  gradleBuildTask = "assemble";

  doCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 build/libs/jspecify-${finalAttrs.version}.jar \
      $out/share/java/jspecify-${finalAttrs.version}.jar

    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "update-jspecify" ''
    ${lib.getExe nix-update} jspecify
    $(nix-build -A jspecify.mitmCache.updateScript)
  '';

  meta = {
    homepage = "https://jspecify.dev";
    description = "Standard Annotations for Java Static Analysis";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    inherit (jre_minimal.meta) platforms;
    maintainers = with lib.maintainers; [ msgilligan ];
  };
})
