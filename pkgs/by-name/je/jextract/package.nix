{ lib
, stdenv
, fetchFromGitHub
, emptyDirectory
, writeText
, makeBinaryWrapper
, gradle
, jdk22
, llvmPackages
}:

let
  gradleInit = writeText "init.gradle" ''
    logger.lifecycle 'Replacing Maven repositories with empty directory...'
    gradle.projectsLoaded {
      rootProject.allprojects {
        buildscript {
          repositories {
            clear()
            maven { url '${emptyDirectory}' }
          }
        }
        repositories {
          clear()
          maven { url '${emptyDirectory}' }
        }
      }
    }
    settingsEvaluated { settings ->
      settings.pluginManagement {
        repositories {
          maven { url '${emptyDirectory}' }
        }
      }
    }
  '';
in

stdenv.mkDerivation {
  pname = "jextract";
  version = "unstable-2024-03-13";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jextract";
    rev = "b9ec8879cff052b463237fdd76382b3a5cd8ff2b";
    hash = "sha256-+4AM8pzXPIO/CS3+Rd/jJf2xDvAo7K7FRyNE8rXvk5U=";
  };

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
  ];

  env = {
    ORG_GRADLE_PROJECT_llvm_home = llvmPackages.libclang.lib;
    ORG_GRADLE_PROJECT_jdk22_home = jdk22;
  };

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    gradle --console plain --init-script "${gradleInit}" assemble

    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    gradle --console plain --init-script "${gradleInit}" verify
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/
    cp -r ./build/jextract $out/opt/jextract
    makeBinaryWrapper "$out/opt/jextract/bin/jextract" "$out/bin/jextract"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A tool which mechanically generates Java bindings from a native library headers";
    mainProgram = "jextract";
    homepage = "https://github.com/openjdk/jextract";
    platforms = jdk22.meta.platforms;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jlesquembre sharzy ];
  };
}
