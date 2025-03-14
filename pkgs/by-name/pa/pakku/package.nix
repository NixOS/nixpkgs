{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  makeWrapper,
  jdk17,
  pakku,
  jre,
}:
let
  pname = "pakku";
  version = "0.26.0";

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "juraj-hrivnak";
    repo = "Pakku";
    tag = "v${version}";
    hash = "sha256-TQDHf6Kr6SEPyxAhA5jK3rDIZJKg2qCK41a1NnU8PxA=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dfile.encoding=utf-8" ];
  gradleBuildTask = "jvmJar";

  doCheck = false;

  installPhase = ''
    mkdir -p $out/{bin,share/pakku}
    ls -la
    cp build/libs/pakku.jar $out/share/pakku

    makeWrapper ${lib.getExe jre} $out/bin/pakku \
      --add-flags "-jar $out/share/pakku/pakku.jar"
  '';

  meta = with lib; {
    description = "A multiplatform modpack manager for Minecraft: Java Edition.";
    homepage = "https://github.com/juraj-hrivnak/Pakku";

    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = licenses.eupl12;
    mainProgram = "pakku";
    maintainers = [ maintainers.Squawkykaka ];
    platforms = platforms.all;
  };
}
