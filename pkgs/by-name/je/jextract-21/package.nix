{
  lib,
  stdenv,
  fetchFromGitHub,
  emptyDirectory,
  writeText,
  makeBinaryWrapper,
  gradle,
  jdk21,
  llvmPackages,
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
  version = "unstable-2023-11-27";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jextract";
    rev = "8730fcf05c229d035b0db52ee6bd82622e9d03e9"; # Update jextract 21 with latest fixes
    hash = "sha256-Wct/yx5C0EjDtDyXNYDH5LRmrfq7islXbPVIGBR6x5Y=";
  };

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
  ];

  env = {
    ORG_GRADLE_PROJECT_llvm_home = llvmPackages.libclang.lib;
    ORG_GRADLE_PROJECT_jdk21_home = jdk21;
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
    platforms = jdk21.meta.platforms;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sharzy ];
  };
}
