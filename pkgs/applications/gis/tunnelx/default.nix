{ lib
, stdenv
, fetchFromGitHub
, jdk
, jre
, survex
, makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tunnelx";
  version = "2023-07-nix";

  src = fetchFromGitHub {
    owner = "CaveSurveying";
    repo = "tunnelx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H6lHqc9on/pv/KihNcaHPwbWf4JXRkeRqNoYq6yVKqM=";
  };

  nativeBuildInputs = [
    jdk
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    javac -d . src/*.java

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/java
    cp -r symbols Tunnel tutorials $out/java
    # `SURVEX_EXECUTABLE_DIR` must include trailing slash
    makeWrapper ${jre}/bin/java $out/bin/tunnelx \
      --add-flags "-cp $out/java Tunnel.MainBox" \
      --set SURVEX_EXECUTABLE_DIR ${lib.getBin survex}/bin/ \
      --set TUNNEL_USER_DIR $out/java/

    runHook postInstall
  '';

  meta = {
    description = "A program for drawing cave surveys in 2D";
    homepage = "https://github.com/CaveSurveying/tunnelx/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ goatchurchprime ];
    platforms = lib.platforms.linux;
  };
})
