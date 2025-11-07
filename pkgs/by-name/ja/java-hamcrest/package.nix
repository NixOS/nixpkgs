{
  stdenvNoCC,
  fetchFromGitHub,
  gradle,
  jdk,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "java-hamcrest";
  version = "3.0";

  nativeBuildInputs = [ gradle ];

  src = fetchFromGitHub {
    owner = "hamcrest";
    repo = "JavaHamcrest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ntae6XWpD0wEs36YoPsfTl6cSR6ULl6dAJ5oZsV+ih0=";
  };

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/java"
    cp hamcrest/build/libs/*.jar "$out/share/java"

    runHook postInstall
  '';

  meta = {
    homepage = "https://hamcrest.org/JavaHamcrest/";
    description = "Java library containing matchers that can be combined to create flexible expressions of intent";
    platforms = jdk.meta.platforms;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tomodachi94 ];
  };
})
