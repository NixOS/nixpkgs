{ lib
, stdenv
, fetchFromGitHub
, jdk
, makeWrapper
, buildNativeImage ? false
}:

stdenv.mkDerivation rec {
  pname = "dbqn" + lib.optionalString buildNativeImage "-native";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "BQN";
    rev = "v${version}";
    hash = "sha256-AUfT7l7zr/pyG63wX8FMej8RUg7tXC1aroCrunjyw/8=";
  };

  nativeBuildInputs = [
    jdk
    makeWrapper
  ];

  dontConfigure = true;

  postPatch = ''
    patchShebangs --build ./build8
  '';

  buildPhase = ''
    runHook preBuild

    ./build8
  '' + lib.optionalString buildNativeImage ''
    native-image --report-unsupported-elements-at-runtime \
      -H:CLibraryPath=${lib.getLib jdk}/lib -J-Dfile.encoding=UTF-8 \
      -jar BQN.jar dbqn
  '' + ''
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

  '' + (if buildNativeImage then ''
    mv dbqn $out/bin
  '' else ''
    mkdir -p $out/share/dbqn
    mv BQN.jar $out/share/dbqn/

    makeWrapper "${lib.getBin jdk}/bin/java" "$out/bin/dbqn" \
      --add-flags "-jar $out/share/dbqn/BQN.jar"
  '') + ''
    ln -s $out/bin/dbqn $out/bin/bqn

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dzaima/BQN";
    description = "BQN implementation in Java" + lib.optionalString buildNativeImage ", compiled as a native image";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres sternenseemann ];
    inherit (jdk.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/dbqn-native.x86_64-darwin
  };
}
# TODO: Processing app
# TODO: minimalistic JDK
