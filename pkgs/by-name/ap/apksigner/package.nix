{ lib
, stdenv
, fetchgit
, jdk_headless
, gradle
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "apksigner";
  version = "34.0.5-unstable-2024-03-06";

  src = fetchgit {
    # use pname here because the final jar uses this as the filename
    name = pname;
    url = "https://android.googlesource.com/platform/tools/apksig";
    rev = "ac5cbb07d87cc342fcf07715857a812305d69888";
    hash = "sha256-sLAs7XEkhNkQjB/nhBODxI3QzxFvLWM1SBKDuXp6gvw=";
  };

  postPatch = ''
    cat >> build.gradle <<EOF

    apply plugin: 'application'
    mainClassName = "com.android.apksigner.ApkSignerTool"
    sourceSets.main.java.srcDirs = [ 'src/apksigner/java', 'src/main/java' ]
    jar {
        manifest { attributes "Main-Class": "com.android.apksigner.ApkSignerTool" }
        from { (configurations.runtimeClasspath).collect { it.isDirectory() ? it : zipTree(it) } } {
            exclude 'META-INF/*.RSA', 'META-INF/*.SF', 'META-INF/*.DSA', 'META-INF/native/*.dll'
        }
        from('src/apksigner/java') {
            include 'com/android/apksigner/*.txt'
        }
    }
    tasks.named("processTestResources") { dependsOn("extractTestProto") }
    EOF
    sed -i -e '/conscrypt/s/testImplementation/implementation/' build.gradle
  '';

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  doCheck = true;

  nativeBuildInputs = [ gradle makeWrapper ];

  installPhase = ''
    install -Dm444 build/libs/apksigner.jar -t $out/lib
    makeWrapper "${jdk_headless}/bin/java" "$out/bin/apksigner" \
      --add-flags "-jar $out/lib/apksigner.jar"
  '';

  meta = with lib; {
    description = "Command line tool to sign and verify Android APKs";
    mainProgram = "apksigner";
    homepage = "https://developer.android.com/studio/command-line/apksigner";
    license = licenses.asl20;
    maintainers = with maintainers; [ linsui ];
    platforms = platforms.unix;
  };
}
